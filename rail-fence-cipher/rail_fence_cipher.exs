defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t, pos_integer) :: String.t
  def encode(str, 1), do: str
  def encode(str, rails) do
    str
    |> to_charlist
    |> Enum.zip(Stream.cycle(Enum.to_list(1..rails) ++ Enum.reverse(2..rails - 1)))
    |> Enum.group_by(fn({_, x}) -> x end, fn({x, _}) -> x end)
    |> Enum.map_join(fn({_, row}) -> row end)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, 1), do: str
  def decode(str, rails) do
    sequence = Enum.to_list(1..rails) ++ Enum.reverse(2..rails - 1) |> Stream.cycle |> Enum.take(String.length(str))
    str
    |> to_charlist
    |> Enum.zip(Enum.sort(sequence))
    |> Enum.chunk_by(fn({_, x}) -> x end)
    |> Enum.map(fn(x) -> Enum.map(x, fn({x, _}) -> x end) end)
    |> merge(sequence, [])
    |> to_string
  end

  defp merge(_, [], acc), do: acc
  defp merge(data, [i | rest], acc) do
    {[letter | rest_row], rest_data} = List.pop_at(data, i - 1)
    merge(List.insert_at(rest_data, i - 1, rest_row), rest, acc ++ [letter])
  end
end
