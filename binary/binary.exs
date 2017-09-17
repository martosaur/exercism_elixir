defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    if string =~ ~r/^[01]*$/ do
      string
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.reduce(0, fn({digit, power}, acc) -> acc + digit * :math.pow(2, power) end)
    else
      0
    end
  end
end
