defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) :: :calendar.datetime

  def from(date_time) do
    with {:ok, start} <- NaiveDateTime.from_erl(date_time) do
      start
      |> NaiveDateTime.add(1_000_000_000, :seconds)
      |> NaiveDateTime.to_erl
    end    
  end
end
