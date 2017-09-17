defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(_s, _size) when _size <= 0 do
    []
  end
  def slices(_s, _size) do
    _s
    |> String.split("", trim: true)
    |> Enum.chunk_every(_size, 1, :discard)
    |> Enum.map(&Enum.join(&1))
    |> Enum.uniq
  end
end
