defmodule Bowling do
  defstruct rolls: [], frame: []

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    %Bowling{rolls: [], frame: []}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t
  def roll(_, roll) when roll < 0,  do: {:error, "Negative roll is invalid"}
  def roll(_, roll) when roll > 10, do: {:error, "Pin count exceeds pins on the lane"}
  def roll(%{rolls: r}, _) when length(r) == 10, do: {:error, "Cannot roll after game is over"}
  def roll(%{frame: f} = game, roll) do
    %{game | frame: [roll | f]}
    # |> IO.inspect
    |> self_check_game
    # |> IO.inspect
  end

  # game is closed
  defp self_check_game(%{rolls: r}) when length(r) == 10, do: {:error, "Game if full"}
  # general frame rules
  defp self_check_game(%{rolls: r, frame: [10]} = game)   when length(r) < 9,                do: %{game | rolls: [game.frame | r], frame: []}
  defp self_check_game(%{rolls: r, frame: [b, a]} = game) when length(r) < 9 and b + a > 10, do: {:error, "Pin count exceeds pins on the lane"}
  defp self_check_game(%{rolls: r, frame: [b, a]} = game) when length(r) < 9,                do: %{game | rolls: [game.frame | r], frame: []}
  # last frame rules
  defp self_check_game(%{rolls: r, frame: [c, b, 10]} = game) when length(r) == 9 and c + b > 10 and b != 10, do: {:error, "Pin count exceeds pins on the lane"}
  defp self_check_game(%{rolls: r, frame: [b, 10]} = game)    when length(r) == 9,                            do: game
  defp self_check_game(%{rolls: r, frame: [b, a]} = game)     when length(r) == 9 and a + b == 10,            do: game
  defp self_check_game(%{rolls: r, frame: [b, a]} = game)     when length(r) == 9,                            do: %{game | rolls: [game.frame | r], frame: []}
  defp self_check_game(%{rolls: r, frame: [c, b, a]} = game)  when length(r) == 9,                            do: %{game | rolls: [game.frame | r], frame: []}
  # if everything seems ok
  defp self_check_game(game), do: game

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t
  def score(%{rolls: r}) when length(r) != 10, do: {:error, "Score cannot be taken until the end of the game"}
  def score(%{rolls: r}) do
    r
    |> List.flatten
    |> Enum.reverse
    |> score(0)
  end
  def score([], acc), do: acc
  def score([a], acc), do: acc
  def score([10, b, c], acc), do: acc + 10 + b + c
  def score([10, b, c | rest], acc), do: score([b, c | rest], acc + 10 + b + c)
  def score([a, b, c | rest], acc) when a + b == 10, do: score([c | rest], acc + 10 + c)
  def score([a, b | rest], acc), do: score(rest, acc + a + b)
end
