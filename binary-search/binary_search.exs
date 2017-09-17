defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key), do: do_search(Enum.with_index(Tuple.to_list(numbers)), key)

  defp do_search(numbers, key) do
    {left, right} = numbers
    |> Enum.split(round(Float.floor(length(numbers) / 2)))
    search(left, right, key)
  end
  defp search(left, [{mid, i} | right], mid), do: {:ok, i}
  defp search([], _, key), do: :not_found
  defp search(left, [{mid, i} | right], key) when key > mid, do: do_search(right, key)
  defp search(left, [{mid, i} | right], key) when key < mid, do: do_search(left, key)
end
