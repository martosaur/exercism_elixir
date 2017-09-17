defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """

  @abc 'abcdefghijklmnopqrstuvwxyz'

  def encode(plaintext, key) do
    plaintext
    |> to_charlist
    |> Enum.zip(Stream.cycle(to_charlist(key)))
    |> Enum.map(fn({t, key}) -> encode_letter(t, key) end)
    |> to_string
  end

  def encode_letter(t, key) when t in @abc do
    with {tail, head} <- @abc |> Enum.split_while(&(&1 != key)) do
      head ++ tail
      |> Enum.at(Enum.find_index(@abc, &(&1 == t)))
    end
  end
  def encode_letter(t, _), do: t

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) do
    ciphertext
    |> to_charlist
    |> Enum.zip(Stream.cycle(to_charlist(key)))
    |> Enum.map(fn({t, key}) -> decode_letter(t, key) end)
    |> to_string
  end

  def decode_letter(t, key) when t in @abc do
    i = with {tail, head} <- @abc |> Enum.split_while(&(&1 != key)) do
      head ++ tail
      |> Enum.find_index(&(&1 == t))
    end
    Enum.at(@abc, i)
  end
  def decode_letter(t, _), do: t
end
