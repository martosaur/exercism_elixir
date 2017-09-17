defmodule Dominoes do

  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?(dominoes, tried \\ [])
  def chain?([], []), do: true
  def chain?([], _), do: false
  def chain?([{a, b} | rest], tried) do
    with one <- chainable?([{a, b}], rest ++ tried),
      two <- chainable?([{b, a}], rest ++ tried),
      true <- one or two do
        true
    else
      _ -> chain?(rest, [{a, b} | tried])
    end
  end

  defp chainable?(chain, []) do
    {a, _} = List.first(chain)
    {_, b} = List.last(chain)
    a == b
  end
  defp chainable?([{a, _} | _] = chain, pool) do
    pool
    |> Enum.filter(fn({p, q}) -> p == a or q == a end)
    |> Enum.map(fn {^a, p} -> chainable?([{p, a} | chain], pool -- [{a, p}]);
                   {p, ^a} -> chainable?([{p, a} | chain], pool -- [{p, a}]) end)
    |> Enum.any?
  end
end
