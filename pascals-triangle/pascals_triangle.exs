defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num), do: rows([[1]], num - 1) |> Enum.reverse
  defp rows(acc, 0), do: acc
  defp rows([[1]], num), do: rows([[1, 1], [1]], num - 1)
  defp rows([last | rest] = acc, num) do
    row = last
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn([a, b]) -> a + b end)

    rows([[1] ++ row ++ [1] | acc], num - 1)
  end
end
