defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}
  defstruct map: nil

  @spec new(Enum.t) :: t
  def new(enumerable), do: new(enumerable, [])
  def new([], acc), do: acc
  def new([head | rest], acc), do: new(rest, add(acc, head))

  @spec empty?(t) :: boolean
  def empty?([]), do: true
  def empty?(_), do: false

  @spec contains?(t, any) :: boolean
  def contains?([], _), do: false
  def contains?([element | _], element), do: true
  def contains?([_ | rest], element), do: contains?(rest, element)

  @spec subset?(t, t) :: boolean
  def subset?([], _), do: true
  def subset?([head | rest], set), do: if contains?(set, head), do: subset?(rest, set), else: false

  @spec disjoint?(t, t) :: boolean
  def disjoint?(_, []), do: true
  def disjoint?(set1, [head | rest]), do: if contains?(set1, head), do: false, else: disjoint?(set1, rest)

  @spec equal?(t, t) :: boolean
  def equal?([], []), do: true
  def equal?(_, []), do: false
  def equal?([], _), do: false
  def equal?(set1, [head | rest]), do: equal?(set1 -- [head], rest)

  @spec add(t, any) :: t
  def add(set, element), do: unless contains?(set, element), do: [element | set], else: set

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2), do: intersection(custom_set_1, custom_set_2, [])
  def intersection(_, [], acc), do: acc
  def intersection(custom_set_1, [head | rest], acc) do
    acc = if contains?(custom_set_1, head), do: [head | acc], else: acc
    intersection(custom_set_1, rest, acc)
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, []), do: custom_set_1
  def difference(custom_set_1, [head | rest]), do: difference(custom_set_1 -- [head], rest)

  @spec union(t, t) :: t
  def union(custom_set_1, []), do: custom_set_1
  def union(custom_set_1, [head | rest]), do: union(add(custom_set_1, head), rest)
end
