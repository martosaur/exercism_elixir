defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """

  @consonants_like ["ch", "qu", "squ", "thr", "th", "sch"]
  @vowels ["yt", "xr", "a", "e", "i", "o", "u"]

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    for word <- String.split(phrase) do
      start = starts_with_what(word, @consonants_like ++ @vowels)
      word
      |> pigify(start)
      |> ayfy
    end
    |> Enum.join(" ")
  end

  defp starts_with_what(string, []) do
    String.first(string)
  end
  defp starts_with_what(string, [head | tail]) do
    case String.starts_with?(string, head) do
      true -> head
      _ -> starts_with_what(string, tail)
    end
  end

  defp pigify(word, start) when start in @vowels do
    word
  end
  defp pigify(word, start) do
    String.trim_leading(word, start) <> start
  end

  defp ayfy(word) do
    word <> "ay"
  end
end
