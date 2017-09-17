defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @error_number for n <- 1..10, do: 0

  @spec number(String.t) :: String.t
  def number(raw) do
    cond do
      raw =~ ~r/^[\d-~()._+\s]*$/ ->
        ~r/\d/
        |> Regex.scan(raw)
        |> List.flatten
        |> Enum.map(&String.to_integer/1)
        |> remove_country_code
        |> check_validity
      true -> @error_number
    end
    |> Enum.join
  end

  defp remove_country_code([head | tail]) when length([head | tail]) == 11 do
    case head do
      1 -> tail
      _ -> @error_number
    end
  end
  defp remove_country_code(digits) do
    digits
  end

  defp check_validity(number) when length(number) == 10 do
    if Enum.at(number, 0) in 2..9 and Enum.at(number, 3) in 2..9 do
      number
    else
      @error_number
    end
  end
  defp check_validity(number) do
    @error_number
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    raw
    |> number()
    |> String.slice(0..2)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    raw
    |> number()
    |> (&("(#{String.slice(&1, 0..2)}) #{String.slice(&1, 3..5)}-#{String.slice(&1, 6..10)}")).()
  end
end
