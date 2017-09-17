defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @header {"Team", ["MP", "W", "D", "L", "P"]}

  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Enum.reduce(%{}, fn(line, acc) -> append_line(line, acc) end)
    |> Map.to_list
    |> Enum.sort(&team_bigger?/2)
    |> (&([@header | &1])).()
    |> Enum.map_join("\n", &line_to_string/1)
  end

  defp parse_line(raw_line) do
    result = case String.split(raw_line, ";") do
      [winner, loser, "win"] -> %{winner => [1, 1, 0, 0, 3], loser => [1, 0, 0, 1, 0]}
      [loser, winner, "loss"] -> %{winner => [1, 1, 0, 0, 3], loser => [1, 0, 0, 1, 0]}
      [a, b, "draw"] -> %{a => [1, 0, 1, 0, 1], b => [1, 0, 1, 0, 1]}
      _ -> %{}
    end
  end

  defp append_line(raw_line, acc) do
    mix = fn(a, b) -> Enum.zip(a, b) |> Enum.map(fn {a, b} -> a + b end) end

    Map.merge(acc, parse_line(raw_line), fn(_k, a, b) -> mix.(a, b) end)
  end

  defp team_bigger?({team1, results1}, {team2, results2}) do
    cond do
      tl(results1) == tl(results2) -> team1 < team2
      true -> tl(results1) > tl(results2)
    end
  end

  defp line_to_string({team, results}) do
    Enum.join([
        String.pad_trailing(team, 30) |
        Enum.map(results, &(String.pad_leading(to_string(&1), 2)))
      ], " | ")
  end
end
