defmodule Grep do

  @spec grep(String.t, [String.t], [String.t]) :: String.t
  def grep(pattern, flags, files) when length(files) > 1, do: do_grep(pattern, ["-L" | flags], files)
  def grep(pattern, flags, files), do: do_grep(pattern, flags, files)

  defp do_grep(pattern, flags, []), do: ""
  defp do_grep(pattern, flags, [head | rest]) do
    if "-l" in flags do
      quick_grep(pattern, flags, head)
    else
      full_grep(pattern, flags, head)
    end
    |> Kernel.<>(do_grep(pattern, flags, rest))
  end

  defp full_grep(pattern, flags, filename) do
    filename
    |> File.stream!
    |> Enum.with_index
    |> Enum.map(fn(x) -> grep_line(x, pattern, flags, filename) end)
    |> Enum.join
  end

  defp quick_grep(pattern, flags, filename) do
    filename
    |> File.stream!
    |> Enum.to_list
    |> quick_grep_lines(pattern, flags, filename)
  end

  defp quick_grep_lines([], pattern, flags, filename), do: ""
  defp quick_grep_lines([line | rest], pattern, flags, filename) do
    if do_match(line, pattern, flags), do: filename <> "\n", else: quick_grep_lines(rest, pattern, flags, filename)
  end

  defp grep_line({line, i}, pattern, flags, filename) do
    cond do
      do_match(line, pattern, flags) -> line |> append_number(i, flags) |> append_filename(flags, filename)
      true -> ""
    end
  end

  defp do_match(line, pattern, flags) do
    if "-v" in flags do
      !(line =~ get_regex(pattern, flags))
    else
      line =~ get_regex(pattern, flags)
    end
  end

  defp append_number(line, index, flags) do
    if "-n" in flags, do: "#{index + 1}:#{line}", else: line
  end

  defp append_filename(line, flags, filename) do
    if "-L" in flags, do: "#{filename}:#{line}", else: line
  end

  defp get_regex(pattern, flags) do
    params = if "-i" in flags, do: [:caseless], else: []
    pattern = if "-x" in flags, do: "^" <> pattern <> "$", else: pattern
    Regex.compile!(pattern, params)
  end
end
