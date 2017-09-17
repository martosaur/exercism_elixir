defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    for a <- min_factor..max_factor, b <- min_factor..max_factor, palindrome?(a * b) do
      {a * b, [a, b]}
    end
    |> all_min_max
  end

  # start
  defp all_min_max(all), do: all_min_max(all, nil, nil)
  defp all_min_max([{product, factors} | tail], nil, nil), do: all_min_max(tail, {product, [factors]}, {product, [factors]})
  # finish
  defp all_min_max([], {p_min, fs_min}, {p_max, fs_max}) do
    %{
      p_max => Enum.uniq_by(fs_max, &Enum.sort/1),
      p_min => Enum.uniq_by(fs_min, &Enum.sort/1),
    }
  end
  # same products, accumulate factors
  defp all_min_max([{product, fs} | tail], {product, fs_acc}, max) do
    all_min_max(tail, {product, fs_acc ++ [fs]}, max)
  end
  defp all_min_max([{product, fs} | tail], min, {product, fs_acc}) do
    all_min_max(tail, min, {product, fs_acc ++ [fs]})
  end
  # different products, replace
  defp all_min_max([{p, fs} | tail], {p_min, _} = min, {p_max, _} = max) do
    cond do
      p < p_min -> all_min_max(tail, {p, [fs]}, max)
      p > p_max -> all_min_max(tail, min, {p, [fs]})
      true -> all_min_max(tail, min, max)
    end
  end

  defp palindrome?(i) do
    String.reverse(to_string(i)) == to_string(i)
  end
end
