defmodule TwelveDays do
  @numbers ["first", "second", "third", "fourth", "fifth", "sixth", "seventh",
   "eighth", "ninth", "tenth", "eleventh", "twelfth"]

  @presents [
    "a Partridge in a Pear Tree",
    "two Turtle Doves",
    "three French Hens",
    "four Calling Birds",
    "five Gold Rings",
    "six Geese-a-Laying",
    "seven Swans-a-Swimming",
    "eight Maids-a-Milking",
    "nine Ladies Dancing",
    "ten Lords-a-Leaping",
    "eleven Pipers Piping",
    "twelve Drummers Drumming",
  ]

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) when number in 1..12 do
    index = number - 1
    [head | tail] = Enum.slice(@presents, 0..index)
    if tail == [] do
      tail = [head]
    else
      tail = Enum.reverse(tail) ++ ["and #{head}"]
    end
    Enum.join([
      "On the #{Enum.at(@numbers, index)} day of Christmas my true love gave to me" |
      tail
      ], ", ") <> "."
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    Enum.map(starting_verse..ending_verse, &verse(&1))
    |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing():: String.t()
  def sing do
    verses(1, 12)
  end
end
