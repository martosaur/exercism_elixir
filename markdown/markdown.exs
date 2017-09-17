defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t) :: String.t
  def parse(m) do
    m
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> Enum.join
    |> patch
  end

  defp process("#" <> _ = line), do: parse_header(line)
  defp process("* " <> line), do: parse_list(line)
  defp process(line), do: "<p>" <> parse_clean_line(line) <> "</p>"

  defp parse_header(header) do
    [h | rest] = header
    |> String.split

    level = String.length(h)
    rest = Enum.join(rest, " ")
    "<h#{level}>#{rest}</h#{level}>"
  end

  defp parse_list(line) do
    "<li>" <> parse_clean_line(line) <> "</li>"
  end

  defp parse_clean_line(line) do
    line
    |> String.split
    |> Enum.map(&replace_md_with_tag/1)
    |> Enum.join(" ")
  end

  defp replace_md_with_tag(w) do
    w
    |> replace_prefix_md
    |> replace_suffix_md
  end

  defp replace_prefix_md(w) do
    w
    |> String.replace_leading("__", "<strong>")
    |> String.replace_leading("_", "<em>")
  end

  defp replace_suffix_md(w) do
    w
    |> String.replace_trailing("__", "</strong>")
    |> String.replace_trailing("_", "</em>")
  end

  defp patch(l) do
    l
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
