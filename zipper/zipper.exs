defmodule BinTree do
  import Inspect.Algebra
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat ["(", to_doc(v, opts),
            ":", (if l, do: to_doc(l, opts), else: ""),
            ":", (if r, do: to_doc(r, opts), else: ""),
            ")"]
  end
end

defmodule Zipper do

  defstruct tree: nil, actions: [], focus: nil

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t) :: Z.t
  def from_tree(bt) do
    %Zipper{tree: bt, focus: bt}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree(%{tree: bt}) do
    bt
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value(%{focus: %{value: v}}), do: v

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  def left(%{focus: %{left: nil}}), do: nil
  def left(%{focus: %{left: l}} = z) do
    %{z | actions: [:left| z.actions], focus: l}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t) :: Z.t | nil
  def right(%{focus: %{right: nil}}), do: nil
  def right(%{focus: %{right: r}} = z) do
    %{z | actions: [:right| z.actions], focus: r}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up(%{actions: []}), do: nil
  def up(%{actions: [last | rest]} = z) do
    %{z | actions: rest}
    |> refresh_focus
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(%{tree: bt, actions: actions} = z, v) do
    %{z | tree: set_value(bt, Enum.reverse(actions), v)}
    |> refresh_focus
  end
  defp set_value(bt, [], v), do: %{bt | value: v}
  defp set_value(%{right: r} = bt, [:right | rest], v), do: %{bt | right: set_value(r, rest, v)}
  defp set_value(%{left: l} = bt, [:left | rest], v), do: %{bt | left: set_value(l, rest, v)}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(%{tree: bt, actions: actions} = z, l) do
    %{z | tree: set_left(bt, Enum.reverse(actions), l)}
    |> refresh_focus
  end
  defp set_left(bt, [], v), do: %{bt | left: v}
  defp set_left(%{right: r} = bt, [:right | rest], v), do: %{bt | right: set_left(r, rest, v)}
  defp set_left(%{left: l} = bt, [:left | rest], v), do: %{bt | left: set_left(l, rest, v)}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(%{tree: bt, actions: actions} = z, r) do
    %{z | tree: set_right(bt, Enum.reverse(actions), r)}
    |> refresh_focus
  end
  defp set_right(bt, [], v), do: %{bt | right: v}
  defp set_right(%{right: r} = bt, [:right | rest], v), do: %{bt | right: set_right(r, rest, v)}
  defp set_right(%{left: l} = bt, [:left | rest], v), do: %{bt | left: set_right(l, rest, v)}

  defp refresh_focus(%{tree: bt, actions: actions} = z) do
    %{z | focus: refresh_focus(bt, actions)}
  end
  defp refresh_focus(bt, []), do: bt
  defp refresh_focus(%{right: r}, [:right | rest]), do: refresh_focus(r, rest)
  defp refresh_focus(%{left: l}, [:left | rest]), do: refresh_focus(l, rest)
end
