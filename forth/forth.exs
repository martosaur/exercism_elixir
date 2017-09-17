defmodule Forth do
  @opaque evaluator :: any
  defstruct stack: [], custom_commands: %{}

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %Forth{}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t) :: evaluator
  def eval(ev, s) do
    seq = Regex.scan(~r/[^\p{Z}]+/u, String.upcase(s))
    |> List.flatten
    |> Enum.map(fn(i) ->
      case Integer.parse(i) do
        {int, _} -> int
        :error -> i
      end
    end)

    do_eval(ev, seq)
  end

  @infix_commands ["+", "-", "*", "/", "SWAP", "OVER"]
  @unary_commands ["DUP", "DROP"]

  defp do_eval(%{stack: [command]}, _) when command in @unary_commands, do: raise(Forth.StackUnderflow)
  defp do_eval(%{stack: [command, a | rest]} = ev, s) when command in @unary_commands do
    result = case command do
      "DUP" -> [a, a | rest]
      "DROP" -> rest
    end
    do_eval(%{ev | stack: result}, s)
  end
  defp do_eval(%{stack: [command]}, _) when command in @infix_commands, do: raise(Forth.StackUnderflow)
  defp do_eval(%{stack: [command, a]}, _) when command in @infix_commands, do: raise(Forth.StackUnderflow)
  defp do_eval(%{stack: [command, b, a | rest]} = ev, s) when command in @infix_commands do
    result = case command do
      "+" -> [a + b | rest]
      "-" -> [a - b | rest]
      "*" -> [a * b | rest]
      "/" -> unless b == 0, do: [div(a, b) | rest], else: raise(Forth.DivisionByZero)
      "SWAP" -> [a, b | rest]
      "OVER" -> [a, b, a | rest]
    end
    do_eval(%{ev | stack: result}, s)
  end
  defp do_eval(ev, []), do: ev
  defp do_eval(%{custom_commands: c} = ev, [":", command | rest]) when is_integer(command), do: raise(Forth.InvalidWord)
  defp do_eval(%{custom_commands: c} = ev, [":", command | rest]) do
    {translation, leftovers} = parse_definition(rest)
    do_eval(%{ev | custom_commands: Map.put(c, command, translation)}, leftovers)
  end
  defp do_eval(ev, [head | rest]) do
    cond do
      is_integer(head) -> do_eval(%{ev | stack: [head | ev.stack]}, rest)
      head in Map.keys(ev.custom_commands) -> do_eval(ev, ev.custom_commands[head] ++ rest)
      head in @unary_commands or head in @infix_commands -> do_eval(%{ev | stack: [head | ev.stack]}, rest)
      true -> raise(Forth.UnknownWord)
    end
  end

  defp parse_definition(sec), do: parse_definition(sec, [])
  defp parse_definition([";" | tail], acc), do: {acc, tail}
  defp parse_definition([head | tail], acc), do: parse_definition(tail, acc ++ [head])


  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t
  def format_stack(%{stack: s}) do
    s
    |> Enum.reverse
    |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception [word: nil]
    def message(e), do: "invalid word: #{inspect e.word}"
  end

  defmodule UnknownWord do
    defexception [word: nil]
    def message(e), do: "unknown word: #{inspect e.word}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
