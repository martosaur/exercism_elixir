defmodule Clock do
  defstruct hour: 0, minute: 0

  defimpl String.Chars, for: Clock do
    def to_string(clock) do
      String.pad_leading("#{clock.hour}", 2, "0") <> ":" <> String.pad_leading("#{clock.minute}", 2, "0")
    end
  end

  @doc """
  Returns a string representation of a clock:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) when hour < 0 do
    hours = 24 + rem(hour, 24)
    new(hours, minute)
  end
  def new(hour, minute) when minute < 0 do
    minutes = 60 + rem(minute, 60)
    hours = hour - 1 + div(minute, 60)
    new(hours, minutes)
  end
  def new(hour, minute) do
    minutes = rem(minute, 60)
    hours = rem(hour + div(minute, 60), 24)

    %Clock{hour: hours, minute: minutes}
  end

  @doc """
  Adds two clock times:

      iex> Clock.add(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end
