defmodule Luhn do
  @doc """
  Calculates the total checksum of a number
  """
  @spec checksum(String.t()) :: integer
  def checksum(number) do
    [last | rest] = number
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> Enum.reverse

    rest
    |> Enum.map_every(2, fn(n) ->
        case n * 2 do
          result when result > 9 -> result - 9
          result -> result
        end
      end)
    |> Enum.reduce(&Kernel.+/2)
    |> Kernel.+(last)
  end

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number), do: number |> checksum |> rem(10) == 0

  @doc """
  Creates a valid number by adding the correct
  checksum digit to the end of the number
  """
  @spec create(String.t()) :: String.t()
  def create(number) do
    diff = number
    |> Kernel.<>("0")
    |> checksum
    |> rem(10)

    number <> to_string(rem(10 - diff, 10))
  end
end
