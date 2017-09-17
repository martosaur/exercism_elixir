defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t) :: String.t
  def encode(str) do
    str
    |> sanitize
    |> to_rectangle
    |> transpose
    |> join_gracefully
  end

  defp sanitize(str) do
    str
    |> String.downcase
    |> to_charlist
    |> Enum.filter(&(&1 in ?a..?z or &1 in ?0..?9))
  end

  defp to_rectangle(chars) do
    {c, _} = Stream.iterate({1, 1}, fn {a, a} -> {a + 1, a}; {a, b} -> {a, b + 1} end)
    |> Enum.find(fn {c, r} -> c * r >= length(chars) end)

    Enum.chunk_every(chars, c, c, Stream.cycle('\s'))
  end

  defp transpose(rows) do
    rows
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  defp join_gracefully(columns) do
    columns
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.trim/1)
    |> Enum.join(" ")
  end
end
