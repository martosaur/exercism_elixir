defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0 do
    nth([], 1, count)
  end
  defp nth([head | _] = primes, _, count) when length(primes) == count do
    head
  end
  defp nth(primes, next, count) do
    primes = if is_prime?(next), do: [next | primes], else: primes
    nth(primes, next + 1, count)
  end

  defp is_prime?(1) do
    false
  end
  defp is_prime?(2) do
    true
  end
  defp is_prime?(3) do
    true
  end
  defp is_prime?(n) do
    is_prime?(2, n)
  end
  defp is_prime?(next, n) when next == div(n, 2) do
    case rem(n, next) do
      0 -> false
      _ -> true
    end
  end
  defp is_prime?(next, n) do
    case rem(n, next) do
      0 -> false
      _ -> is_prime?(next + 1, n)
    end
  end
end
