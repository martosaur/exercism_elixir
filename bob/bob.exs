defmodule Bob do
  def hey(input) do
    cond do
        String.ends_with?(input, "?") -> "Sure."
        String.trim(input) == "" -> "Fine. Be that way!"
        input =~ ~r/^(?=.*(\p{Lu}))(\p{Lu}|\W|\d)+$/u -> "Whoa, chill out!"
        true -> "Whatever."
    end
  end
end
