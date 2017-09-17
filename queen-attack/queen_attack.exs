defmodule Queens do
  @type t :: %Queens{ black: {integer, integer}, white: {integer, integer} }
  defstruct black: {7, 3}, white: {0, 3}

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(), do: %Queens{}
  def new(same, same), do: raise(ArgumentError)
  def new(white, black), do: %Queens{black: black, white: white}

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    for x <- 0..7 do
      for y <- 0..7 do
        case queens do
          %Queens{black: {^x, ^y}} -> "B"
          %Queens{white: {^x, ^y}} -> "W"
          _ -> "_"
        end
      end
      |> Enum.join(" ")
    end
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: {x, _}, white: {x, _}}), do: true
  def can_attack?(%Queens{black: {_, y}, white: {_, y}}), do: true
  def can_attack?(%Queens{black: {x1, y1}, white: {x2, y2}}) when abs(x1 - x2) == abs(y1 - y2), do: true
  def can_attack?(_), do: false
end
