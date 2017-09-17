defmodule CollatzConjecture do

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(number :: pos_integer) :: pos_integer
  def calc(input) when input > 0 and is_integer(input), do: calc(input, 0)
  defp calc(1, acc), do: acc
  defp calc(input, acc) do
    case rem(input, 2) do
      0 -> div(input, 2)
      _ -> input * 3 + 1
    end
    |> calc(acc + 1)
  end
end
