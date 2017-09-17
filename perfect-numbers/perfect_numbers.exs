defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: ({ :ok, atom } | { :error, String.t() })
  def classify(number) when number < 1, do: {:error, "Classification is only possible for natural numbers."}
  def classify(number), do: classify(number, 1, 0)

  defp classify(number, number, number),                            do: {:ok, :perfect}
  defp classify(number, number, acc) when acc < number,             do: {:ok, :deficient}
  defp classify(number, _, acc)      when acc > number,             do: {:ok, :abundant}
  defp classify(number, factor, acc) when rem(number, factor) == 0, do: classify(number, factor + 1, acc + factor)
  defp classify(number, factor, acc),                               do: classify(number, factor + 1, acc)
end
