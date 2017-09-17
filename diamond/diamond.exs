defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t
  def build_shape(letter) do
    range = Enum.with_index(letter..?A)
    for {l, i} <- range do
      [center | right] = List.duplicate(?\s, length(range) - i - 1) ++ [l] ++ List.duplicate(?\s, i)
      Enum.reverse(right) ++ [center | right]
    end
    |> repeat
    |> Enum.join("\n")
    |> String.replace_suffix("", "\n")
  end

  defp repeat([center | rest]), do: repeat(rest, [center])
  defp repeat([next | rest], acc), do: repeat(rest, [next] ++ acc ++ [next])
  defp repeat([], acc), do: acc
end
