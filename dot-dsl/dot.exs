defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []

  def new() do
    %Graph{}
  end

  def add_node(graph, name, parameter \\ []) do
    %{graph | nodes: Enum.sort([{name, parameter} | graph.nodes])}
  end

  def add_edge(graph, from, to, parameter \\ []) do
    %{graph | edges: Enum.sort([{from, to, parameter} | graph.edges])}
  end

  def add_attr(graph, attr) do
    %{graph | attrs: Enum.sort(graph.attrs ++ attr)}
  end
end

defmodule Dot do
  defmacro graph(do: nil) do
    quote do
      %Graph{}
    end
  end
  defmacro graph(do: block) do
    block = unless is_list(block), do: [block]
    parse_expr(block)
  end

  def parse_expr([]), do: quote do: %Graph{}
  def parse_expr([{:__block__, _, body}]), do: parse_expr(body)
  def parse_expr([{:--, _, [{a, _, _}, {b, _, [attr]}]} | rest]) when is_atom(a) and is_atom(b), do: quote do: Graph.add_edge(unquote(parse_expr(rest)), unquote(a), unquote(b), unquote(attr))
  def parse_expr([{:--, _, [{a, _, _}, {b, _, _}]} | rest]) when is_atom(a) and is_atom(b), do: quote do: Graph.add_edge(unquote(parse_expr(rest)), unquote(a), unquote(b))
  def parse_expr([{:graph, _, [attr]} | rest]), do: quote do: Graph.add_attr(unquote(parse_expr(rest)), unquote(attr))
  def parse_expr([{a, _, nil} | rest]) when is_atom(a), do: quote do: Graph.add_node(unquote(parse_expr(rest)), unquote(a))
  def parse_expr([{a, _, [[]]} | rest]) when is_atom(a), do: quote do: Graph.add_node(unquote(parse_expr(rest)), unquote(a))
  def parse_expr([{a, _, [[{key, value}]]} | rest]) when is_atom(a), do: quote do: Graph.add_node(unquote(parse_expr(rest)), unquote(a), unquote([{key, value}]))
  def parse_expr(smth), do: raise(ArgumentError)
end
