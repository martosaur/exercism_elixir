defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @pairs %{
    "]" => "[",
    "}" => "{",
    ")" => "(",
  }
  @opening Map.values(@pairs)
  @closing Map.keys(@pairs)

  @spec check_brackets(String.t) :: boolean
  def check_brackets(str) do
    str
    |> String.graphemes
    |> check_brackets([])
  end
  defp check_brackets([], []) do
    true
  end
  defp check_brackets([], _) do
    false
  end
  defp check_brackets([closing | rest], []) when closing in @closing do
    false
  end
  defp check_brackets([opening | rest], acc) when opening in @opening do
    acc = [opening | acc]
    check_brackets(rest, acc)
  end
  defp check_brackets([closing | rest], [last | previous]) when closing in @closing do
    case last == @pairs[closing] do
      true -> check_brackets(rest, previous)
      false -> false
    end
  end
  defp check_brackets([something | rest], acc) do
    check_brackets(rest, acc)
  end
end
