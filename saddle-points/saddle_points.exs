defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(&(Enum.map(&1, fn(i) -> String.to_integer(i) end)))
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    rs = rows(str)
    for i <- 0..length(hd(rs)) do
      rs
      |> Enum.map(&Enum.at(&1, i))
    end
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    max_in_rows = for {row, x} <- Enum.with_index(rows(str)) do
      for {el, y} <- Enum.with_index(row), el == Enum.max(row), do: {x, y}
    end
    |> List.flatten
    |> MapSet.new

    min_in_columns = for {column, y} <- Enum.with_index(columns(str)) do
      for {el, x} <- Enum.with_index(column), el == Enum.min(column), do: {x, y}
    end
    |> List.flatten
    |> MapSet.new

    MapSet.intersection(max_in_rows, min_in_columns)
    |> MapSet.to_list
  end
end
