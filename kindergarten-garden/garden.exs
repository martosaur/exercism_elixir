defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @names [:alice, :bob, :charlie, :david, :eve, :fred, :ginny, :harriet, :ileana, :joseph, :kincaid, :larry]
  @plants %{
    ?V => :violets,
    ?C => :clover,
    ?R => :radishes,
    ?G => :grass,
  }

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @names) do
    [row1, row2] = info_string
    |> String.split("\n")
    |> Enum.map(&to_charlist/1)

    stream = Enum.zip(row1, row2)
    |> Enum.chunk_every(2)


    all_children = for name <- student_names, into: %{}, do: {name, {}}
    children_with_cups = for {name, cups} <- Enum.zip(Enum.sort(student_names), stream), into: %{} do
      [{p1, p3}, {p2, p4}] = cups
      plants = [p1, p2, p3, p4]
      |> Enum.map(&(@plants[&1]))
      |> List.to_tuple
      {name, plants}
    end
    Map.merge(all_children, children_with_cups)
  end
end
