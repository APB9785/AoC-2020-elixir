defmodule Day6 do
  def run do
    input = parse_input()

    IO.puts(header() <> main_1(input))

    IO.puts("\nPart 2:  " <> main_2(input) <> "\n")
  end

  def parse_input do
    File.read!("day6input.txt")
    |> String.slice(0..-2)      # Must remove trailing newline at end of file.
    |> String.split("\n\n")
    |> Enum.map(&String.graphemes/1)
  end

  def main_1(input) do
    input
    |> Enum.map(&count_group_any/1)
    |> Enum.sum
    |> Integer.to_string
  end

  def main_2(input) do
    input
    |> Enum.map(&count_group_all/1)
    |> Enum.sum
    |> Integer.to_string
  end

  def count_group_any(str) do
    str
    |> Enum.uniq
    |> Enum.reject(&(&1=="\n"))
    |> Enum.join
    |> String.length
  end

  def count_group_all(str) do
    counts = Enum.frequencies(str)
    participants = Map.get(counts, "\n", 0) + 1
    shared_responses = Enum.filter(counts, fn {k, v} -> v == participants end)

    length(shared_responses)
  end

  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 6" <>
      "\n**********************\n\nPart 1:  "
  end
end

Day6.run()
