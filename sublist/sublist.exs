defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) when a == b do
    :equal
  end
  def compare([], b) do
    :sublist
  end
  def compare(a, []) do
    :superlist
  end
  def compare(a, b) do
    case {is_sublist?(a, b), is_sublist?(b, a)} do
      {true, false} -> :sublist
      {false, true} -> :superlist
      {false, false} -> :unequal
    end
  end

  defp is_sublist?(a, b) when length(a) > length(b) do
    false
  end
  defp is_sublist?(a, b) do
    if b
      |> Enum.chunk_every(length(a), 1, :discard)
      |> Enum.map(&(&1 === a))
      |> Enum.any?() do
        true
      else
        false
      end
  end
end
