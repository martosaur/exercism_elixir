defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
    for word <- candidates, is_anagram?(base, word), do: word
  end

  defp is_anagram?(s1, s2) do
    [s1, s2] = Enum.map([s1, s2], &sanitize/1)
    (s1 != s2) and (Enum.sort(s1) == Enum.sort(s2))
  end

  defp sanitize(s) do
    s
    |> String.downcase
    |> String.graphemes
  end
end
