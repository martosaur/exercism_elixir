defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """

  @alphabet 'abcdefghijklmnopqrstuvwxyz'

  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    plaintext
    |> String.downcase
    |> to_charlist
    |> abc_to_cba
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
  end

  @spec decode(String.t) :: String.t
  def decode(cipher) do
    cipher
    |> to_charlist
    |> cba_to_abc
    |> to_string
  end

  defp abc_to_cba(chars) do
    for c <- chars, c in ?0..?9 or c in ?a..?z do
      cond do
        c in @alphabet -> Enum.at(@alphabet, -1 * (Enum.find_index(@alphabet, &(&1 == c)) + 1))
        true -> c
      end
    end
  end

  defp cba_to_abc(chars) do
    for c <- chars, c in ?0..?9 or c in ?a..?z do
      cond do
        c in @alphabet -> Enum.at(@alphabet, -1 * (Enum.find_index(@alphabet, &(&1 == c)) + 1))
        true -> c
      end
    end
  end
end
