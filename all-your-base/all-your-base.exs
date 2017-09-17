defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list
  def convert(digits, base_a, base_b) do
    case is_valid?(digits, base_a, base_b) do
      false -> nil
      true ->
        digits
        |> to_decimal(base_a)
        |> from_decimal(base_b)
        |> trim_leading_zero
    end
  end

  def to_decimal(digits, base) do
    digits
    |> Enum.reverse
    |> Enum.zip(0..length(digits) - 1)
    |> Enum.reduce(0, fn({digit, power}, acc) -> acc + digit * :math.pow(base, power) end)
    |> round
  end

  def from_decimal(0, _) do
    [0]
  end
  def from_decimal(number, base) do
    from_decimal(div(number, base), base) ++ [rem(number, base)]
  end

  defp trim_leading_zero([0 | tail]) when length(tail) > 0, do: tail
  defp trim_leading_zero(digits), do: digits

  defp is_valid?([], _, _), do: false
  defp is_valid?(_, base_a, base_b) when base_a < 2 or base_b < 2, do: false
  defp is_valid?(digits, base_a, base_b), do: Enum.all?(digits, &(&1 >= 0 and &1 < base_a))
end
