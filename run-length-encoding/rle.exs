defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t) :: String.t
  def encode(string) do
    string
    |> String.split("")
    |> Enum.chunk_by(&(&1))
    |> Enum.flat_map(fn(x) -> [length(x), hd(x)] end)
    |> Enum.reject(&(&1 == 1))
    |> Enum.join()
  end

  @spec decode(String.t) :: String.t
  def decode("") do
    ""
  end
  def decode(string) do
    case Integer.parse(string) do
      {num, rest} -> {first, rest} = String.split_at(rest, 1)
        String.duplicate(first, num) <> decode(rest)
      :error -> {head, rest} = String.split_at(string, 1)
        head <> decode(rest)
    end
  end
end
