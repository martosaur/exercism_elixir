defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t
  def numerals(number) do
    number
    |> Integer.to_string
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.reverse
    |> Enum.zip([1, 10, 100, 1000])
    |> Enum.reverse
    |> Enum.map_join(fn {n, multiplier} -> to_roman(n * multiplier) end)
  end

  def to_roman(n) when n in 0..3, do: String.duplicate("I", n)
  def to_roman(4), do: "IV"
  def to_roman(5), do: "V"
  def to_roman(n) when n in 6..8, do: "V" <> to_roman(rem(n, 5))
  def to_roman(9), do: "IX"
  def to_roman(n) when n in 10..30, do: String.duplicate("X", div(n, 10))
  def to_roman(40), do: "XL"
  def to_roman(n) when n in 50..80, do: "L" <> to_roman(rem(n, 50))
  def to_roman(90), do: "XC"
  def to_roman(n) when n in 100..300, do: String.duplicate("C", div(n, 100))
  def to_roman(400), do: "CD"
  def to_roman(n) when n in 500..800, do: "D" <> to_roman(rem(n, 500))
  def to_roman(900), do: "CM"
  def to_roman(n) when n in 1000..3000, do: String.duplicate("M", div(n, 1000))
end
