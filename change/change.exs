defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t}
  def generate(coins, target) do
    case coins
          |> Enum.sort(&(&1 >= &2))
          |> do_naive_generate(target) do
            {:ok, result} -> {:ok, Enum.sort(result)}
            error -> error
          end
  end

  def pick_one({:error, _}, res), do: res
  def pick_one(res, {:error, _}), do: res
  def pick_one({:ok, res1}, {:ok, res2}), do: if length(res1) < length(res2), do: {:ok, res1}, else: {:ok, res2}

  def do_naive_generate([], target) do
    case target do
      0 -> {:ok, []}
      _ -> {:error, "cannot change"}
    end
  end
  def do_naive_generate(_, 0) do
    {:ok, []}
  end
  def do_naive_generate(_, target) when target < 0 do
    {:error, "cannot change"}
  end
  def do_naive_generate([head | tail] = coins, target) do
    not_at_all_greedy = do_naive_generate(tail, target)
    greedy = case do_naive_generate(coins, target - head) do
      {:ok, l} -> {:ok, [head | l]}
      error -> error
    end
    not_greedy = case do_naive_generate(tail, target - head) do
      {:ok, l} -> {:ok, [head | l]}
      error -> error
    end
    pick_one(greedy, not_greedy)
    |> pick_one(not_at_all_greedy)
  end
end
