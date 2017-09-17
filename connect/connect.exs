defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t]) :: :none | :black | :white
  def result_for(board) do
    max_x = length(board) - 1
    max_y = String.length(hd(board)) - 1

    xs = get_coordinates(board, ?X)
    os = get_coordinates(board, ?O)
    cond do
      x_won?(xs, max_y) -> :black
      o_won?(os, max_x) -> :white
      true -> :none
    end
  end

  def get_coordinates(board, player) do
    for {row, x} <- Enum.with_index(board) do
      for {c, y} <- Enum.with_index(to_charlist(row)), c == player do
        {x, y}
      end
    end
    |> List.flatten
  end

  def x_won?(x_coords, max_y) do
    x_coords
    |> Enum.filter(fn({_, y}) -> y == 0 end)
    |> Enum.map(fn(start_point) -> x_won?(max_y, start_point, x_coords) end)
    |> Enum.any?
  end
  def x_won?(max_y, {_, max_y}, _, _), do: true
  def x_won?(max_y, {x, y}, x_coords, previous \\ []) do
    x_coords
    |> Enum.filter(fn(coords) -> coords in get_valid_moves({x, y}, previous) end)
    |> Enum.map(fn(coords) -> x_won?(max_y, coords, x_coords, [{x, y} | previous]) end)
    |> Enum.any?
  end

  def o_won?(o_coords, max_x) do
    o_coords
    |> Enum.filter(fn({x, _}) -> x == 0 end)
    |> Enum.map(fn(start_point) -> o_won?(max_x, start_point, o_coords) end)
    |> Enum.any?
  end
  def o_won?(max_x, {max_x, _}, _, _), do: true
  def o_won?(max_x, {x, y}, o_coords, previous \\ []) do
    o_coords
    |> Enum.filter(fn(coords) -> coords in get_valid_moves({x, y}, previous) end)
    |> Enum.map(fn(coords) -> o_won?(max_x, coords, o_coords, [{x, y} | previous]) end)
    |> Enum.any?
  end

  defp get_valid_moves({x, y}, previous) do
    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y}
    ] -- previous
  end
end
