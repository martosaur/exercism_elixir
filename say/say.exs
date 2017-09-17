defmodule Say do
  @doc """
  Translate a positive integer into English.
  """

  @basics %{
  	1 => "one",
  	2 => "two",
  	3 => "three",
  	4 => "four",
  	5 => "five",
  	6 => "six",
  	7 => "seven",
  	8 => "eight",
  	9 => "nine",
  	10 => "ten",
  	11 => "eleven",
  	12 => "twelve",
  	13 => "thirteen",
  	14 => "fourteen",
  	15 => "fifteen",
  	16 => "sixteen",
  	17 => "seventeen",
  	18 => "eighteen",
  	19 => "nineteen",
  	20 => "twenty",
  	30 => "thirty",
  	40 => "forty",
  	50 => "fifty",
  	60 => "sixty",
  	70 => "seventy",
  	80 => "eighty",
  	90 => "ninety",
  }

  @spec in_english(integer) :: {atom, String.t}
  def in_english(number) when number < 0 or number > 999_999_999_999, do: {:error, "number is out of range"}
  def in_english(0), do: {:ok, "zero"}
  def in_english(number) do
	{:ok, do_in_english(number, 1_000_000_000, [])}
  end

  def do_in_english(number, 10, acc) do
	acc ++ [two_digits(number)]
	|> Enum.join(" ")
	|> String.trim
  end
  def do_in_english(number, 100, acc) do
	do_in_english(rem(number, 100), 10, acc ++ [hundreds(div(number, 100))])
  end
  def do_in_english(number, 1_000, acc) do
	do_in_english(rem(number, 1_000), 100, acc ++ [thousands(div(number, 1_000))])
  end
  def do_in_english(number, 1_000_000, acc) do
	do_in_english(rem(number, 1_000_000), 1_000, acc ++ [millions(div(number, 1_000_000))])
  end
  def do_in_english(number, 1_000_000_000, acc) do
	do_in_english(rem(number, 1_000_000_000), 1_000_000, acc ++ [billions(div(number, 1_000_000_000))])
  end

  defp two_digits(number) do
	case div(number, 10) do
		n when n in [0, 1] -> Map.get(@basics, number, "")
		n -> Map.get(@basics, n * 10) <> "-" <> Map.get(@basics, rem(number, 10), "") |> String.trim_trailing("-")
	end
  end

  defp hundreds(0), do: ""
  defp hundreds(number) do
	do_in_english(number, 10, []) <> " hundred"
  end

  defp thousands(0), do: ""
  defp thousands(number) do
	do_in_english(number, 100, []) <> " thousand"
  end

  defp millions(0), do: ""
  defp millions(number) do
	do_in_english(number, 100, []) <> " million"
  end

  defp billions(0), do: ""
  defp billions(number) do
	do_in_english(number, 100, []) <> " billion"
  end
end
