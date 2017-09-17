defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @abc String.graphemes("abcdefghijklmnopqrstuvwxyz")
  @length length(@abc)

  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    for c <- String.graphemes(text), into: "" do
      rotate_char(c, shift)
      |> to_uppercase_maybe(c)
    end
  end

  defp rotate_char(char, shift) do
    with downcase_char <- String.downcase(char),
      true <- Enum.member?(@abc, downcase_char),
      index <- Enum.find_index(@abc, &(&1 == downcase_char)),
      target_index <- rem(index + shift, @length) do
        Enum.at(@abc, target_index)
    else
      _ -> char
    end
  end

  defp to_uppercase_maybe(value_after, value_before) do
    if value_before == String.downcase(value_before) do
      value_after
    else
      String.upcase(value_after)
    end
  end
end
