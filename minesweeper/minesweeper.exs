defmodule Minesweeper do

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t]) :: [String.t]
  def annotate([]), do: []
  def annotate(board) do
    max_x = length(board) - 1
    max_y = String.length(hd(board)) - 1

    mines = get_mines_coords(board)
    digits = get_digits(mines, max_x, max_y)
    compose_field(mines, digits, max_x, max_y)
  end

  def get_mines_coords(board) do
    for {row, x} <- Enum.with_index(board), {c, y} <- Enum.with_index(to_charlist(row)), c == ?*, do: {x, y}
  end

  def get_digits(mines, max_x, max_y) do
    min = 0

    for {x, y} <- mines do
      [{x - 1, y - 1}, {x - 1, y}, {x - 1, y + 1}, {x, y - 1}, {x, y + 1}, {x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}]
    end
    |> List.flatten
    |> Enum.filter(fn({x, y}) -> x in min..max_x and y in min..max_y and {x, y} not in mines end)
    |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def compose_field(mines, digits, max_x, max_y) do
    for x <- 0..max_x do
      for y <- 0..max_y, into: "" do
        cond do
          {x, y} in mines -> <<?*>>
          true -> Map.get(digits, {x, y}, <<?\s>>) |> to_string
        end
      end
    end
  end
end
