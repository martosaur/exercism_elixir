defmodule RobotSimulator do
  defstruct [direction: nil, position: nil]

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: { integer, integer }) :: any
  def create(direction \\ :north, position \\ {0, 0})
  def create(direction, _) when direction not in [:north, :east, :south, :west], do: {:error, "invalid direction"}
  def create(direction, {a, b} = position) when is_integer(a) and is_integer(b) do
    %RobotSimulator{direction: direction, position: position}
  end
  def create(_, _), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t ) :: any
  def simulate(robot, instructions), do: do_simulate(robot, String.graphemes(instructions))

  @right_rotation [north: :east, east: :south, south: :west, west: :north]
  @left_rotation  [north: :west, east: :north, south: :east, west: :south]
  defp do_simulate(robot, []), do: robot
  # Advance
  defp do_simulate(robot, ["A" | tail]) do
    robot = case robot do
      %{direction: :north, position: {x, y}} -> %{robot | position: {x, y + 1}}
      %{direction: :south, position: {x, y}} -> %{robot | position: {x, y - 1}}
      %{direction: :east,  position: {x, y}} -> %{robot | position: {x + 1, y}}
      %{direction: :west,  position: {x, y}} -> %{robot | position: {x - 1, y}}
    end
    do_simulate(robot, tail)
  end
  # Rotate
  defp do_simulate(%{direction: dir} = robot, [rotation | tail]) when rotation in ["L", "R"] do
    new_direction = case rotation do
      "R" -> @right_rotation[dir]
      "L" -> @left_rotation[dir]
    end
    do_simulate(%{robot | direction: new_direction}, tail)
  end
  defp do_simulate(_, _), do: {:error, "invalid instruction"}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: { integer, integer }
  def position(robot) do
    robot.position
  end
end
