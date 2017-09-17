defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency([], _), do: %{}
  def frequency(texts, workers) do
    master = self()
    texts
    |> split_and_divide(workers)
    |> Enum.map(fn(part) ->
          spawn(fn -> send master, count_frequency(part)
        end)
      end)
    |> Enum.reduce(%{}, fn(_, acc) ->
        receive do
          frequency -> Map.merge(acc, frequency, fn(_, v1, v2) -> v1 + v2 end)
        end
      end)
  end

  def split_and_divide(texts, workers) do
    texts
    |> Enum.join
    |> String.downcase
    |> (&Regex.scan(~r/\p{L}/u, &1)).()
    |> List.flatten
    |> divide(workers)
  end

  def divide(_, 0) do
    []
  end
  def divide(l, divide_into) do
    partition = Enum.take_every(l, divide_into)
    [partition | divide(l -- partition, divide_into - 1)]
  end

  def count_frequency(letters) do
    letters
    |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
