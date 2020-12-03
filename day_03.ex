defmodule Day3 do
  def run() do
    input = parse_input()

    part_1 =
      input
      |> travel(3)
      |> Integer.to_string

    IO.puts(header() <> part_1)

    part_2 =
      Enum.reduce([1, 3, 5, 7], 1, &(&2 * travel(input, &1)))
      |> (fn x -> x * travel2(input) end).()
      |> Integer.to_string

    IO.puts("\nPart 2:  " <> part_2 <> "\n")
  end

  def parse_input() do
    File.read!("day3input.txt")
    |> String.split("\n", trim: true)
  end

  # Travel where the slope is -1/x
  def travel(sList, x, idx \\ 0, count \\ 0)
  def travel([], _, _, count), do: count
  def travel([s | t], x, idx, count) do
    wrap = String.length(s)
    if String.at(s, idx) ==  "#" do
      travel(t, x, Integer.mod(idx + x, wrap), count + 1)
    else
      travel(t, x, Integer.mod(idx + x, wrap), count)
    end
  end

  # Alternate version of travel where the slope is -2
  def travel2(sList, idx \\ 0, count \\ 0)
  def travel2([_], _, count), do: count
  def travel2([a | [_ | t]], idx, count) do
    wrap = String.length(a)
    if String.at(a, idx) == "#" do
      travel2(t, Integer.mod(idx + 1, wrap), count + 1)
    else
      travel2(t, Integer.mod(idx + 1, wrap), count)
    end
  end

  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 3" <>
      "\n**********************\n\nPart 1:  "
  end
end

Day3.run()
