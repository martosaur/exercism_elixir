defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @weekdays [
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7,
  ]

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, :first), do: do_meetup(1..7, year, month, weekday)
  def meetup(year, month, weekday, :second), do: do_meetup(8..14, year, month, weekday)
  def meetup(year, month, weekday, :third), do: do_meetup(15..21, year, month, weekday)
  def meetup(year, month, weekday, :fourth), do: do_meetup(22..28, year, month, weekday)
  def meetup(year, month, weekday, :teenth), do: do_meetup(13..19, year, month, weekday)
  def meetup(year, month, weekday, :last), do: do_meetup(Calendar.ISO.days_in_month(year, month)..1, year, month, weekday)

  defp do_meetup(range, year, month, weekday) do
    day = which_day(Enum.to_list(range), year, month, @weekdays[weekday])
    {year, month, day}
  end

  defp which_day([head | tail], year, month, weekday_num) do
    if Calendar.ISO.day_of_week(year, month, head) == weekday_num do
      head
    else
      which_day(tail, year, month, weekday_num)
    end
  end
end
