defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t) :: boolean
  defp isogram?([], acc) do
    true
  end
  defp isogram?([head | tail], acc) do
    case head in acc do
      true -> false
      false -> isogram?(tail, [head | acc])
    end
  end
  def isogram?(sentence) do
    sentence
    |> clean
    |> isogram?([])
  end

  defp clean(sentence) do
    ~r/[a-zA-Z]/
    |> Regex.scan(sentence)
    |> List.flatten
  end
end
