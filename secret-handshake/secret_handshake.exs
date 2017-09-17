defmodule SecretHandshake do

  use Bitwise

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @actions %{
    1 => "wink",
    2 => "double blink",
    4 => "close your eyes",
    8 => "jump",
  }

  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    for {action_code, action_name} <- @actions, (code &&& action_code) != 0 do action_name end
    |> reverse_if_needed(code)
  end

  def reverse_if_needed(sequence, code) do
    if (16 &&& code) == 16 do
      Enum.reverse(sequence)
    else
      sequence
    end
  end
end
