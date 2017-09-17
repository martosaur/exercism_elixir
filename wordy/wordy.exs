defmodule Wordy do

  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t) :: integer
  def answer(question) do
    question
    |> String.downcase
    |> String.split
    |> compile([])
  end

  defp compile(rest, [a, "plus",       b ]), do: compile(rest, [a + b])
  defp compile(rest, [a, "minus",      b ]), do: compile(rest, [a - b])
  defp compile(rest, [a, "multiplied", b ]), do: compile(rest, [a * b])
  defp compile(rest, [a, "divided"   , b ]), do: compile(rest, [a / b])

  defp compile([], [result]), do: result

  defp compile([allowed | tail], stack) when allowed in ["what", "is", "by"], do: compile(tail, stack)
  defp compile([command | tail], stack) when command in ["plus", "minus", "multiplied", "divided"], do: compile(tail, stack ++ [command])

  defp compile([head | tail], stack) do
    case Integer.parse(head) do
      {i, _} -> compile(tail, stack ++ [i])
      :error -> raise(ArgumentError)
    end
  end

end
