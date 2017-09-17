defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    do_primes(Enum.to_list(2..limit), [])
  end

  def do_primes([], primes), do: primes
  def do_primes([next | rest], primes) do
    rest = Enum.reject(rest, &(rem(&1, next) == 0))
    do_primes(rest, primes ++ [next])
  end
end
