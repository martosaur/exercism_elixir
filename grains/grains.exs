defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number in 1..64 do
    {:ok, round(:math.pow(2, number - 1))}
  end
  def square(number)do
    {:error, "The requested square must be between 1 and 64 (inclusive)", }
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    number = 1..64
    |> Enum.map(fn(n) ->  with {:ok, result} <- square(n), do: result end)
    |> Enum.reduce(&(&1 + &2))

    {:ok, number}
  end
end
