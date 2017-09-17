defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @letters %{
    "a" => 10,
    "b" => 11,
    "c" => 12,
    "d" => 13,
    "e" => 14,
    "f" => 15,
  }

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    if is_valid_hex?(hex) do
      hex
      |> String.downcase
      |> String.graphemes
      |> Enum.map(fn(n) ->
          case Map.get(@letters, n) do
            nil -> String.to_integer(n)
            result -> result
          end
        end)
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.reduce(0, fn({n, i}, acc) -> acc + n * :math.pow(16, i) end)
    else
      0
    end
  end

  defp is_valid_hex?(hex), do: hex =~ ~r/^[0-9a-f]*$/i
end
