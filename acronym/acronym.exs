defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    raw_letters = Regex.scan(~r/^\w|\s.|[^\s]\p{Lu}/u, string)

    raw_letters
    |> List.flatten
    |> Enum.map(&String.last(&1))
    |> Enum.map(&String.upcase(&1))
    |> Enum.join
  end
end
