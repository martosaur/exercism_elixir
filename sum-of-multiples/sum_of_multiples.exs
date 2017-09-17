defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    1..limit-1
    |> Enum.filter(&(is_multiple?(&1, factors)))
    |> Enum.sum
  end

  def is_multiple?(number, factors) do
    factors
    |> Enum.map(fn(f) -> rem(number, f) == 0 end)
    |> Enum.any?()
  end
end
