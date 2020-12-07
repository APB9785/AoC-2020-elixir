defmodule Day7 do
  def run do
    input = parse_input()

    IO.puts(header() <> main_1(input))

    IO.puts("\nPart 2:  " <> Integer.to_string(main_2(input)) <> "\n")
  end

  def parse_input do
    File.read!("day7input.txt")
    |> String.split(".\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Map.new
  end

  def main_1(input) do
    Map.keys(input)
    |> List.delete("shiny gold")    # Our bag can't contain itself
    |> Enum.filter(&check_bag?([&1], input))
    |> length
    |> Integer.to_string
  end

  def main_2(dict, bag \\ "shiny gold") do
    case dict[bag] do
      [{:empty}] ->
        0
      next_level ->
        Enum.reduce(next_level, 0,
          fn {n, b}, acc -> acc + n + (n * main_2(dict, b)) end)
    end
  end

  def check_bag?([], _), do: false
  def check_bag?(["shiny gold" | _], _), do: true
  def check_bag?([h | t], dict) do
    case dict[h] do
      [{:empty}] ->
        check_bag?(t, dict)
      bags ->
        Enum.map(bags, &elem(&1, 1))
        |> Kernel.++(t)
        |> check_bag?(dict)
    end
  end

  def parse_line(line) do
    [bag, contents] = String.split(line, " contain ")
    bag = String.slice(bag, 0..-6)
    contents =
      contents
      |> String.split(", ")
      |> Enum.map(fn x ->
           case String.split(x, " ") do
             [n, a, b, _] ->
               {String.to_integer(n), a <> " " <> b}
             ["no", "other", "bags"] ->
               {:empty}
             end
           end)
    {bag, contents}
  end

  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 7" <>
      "\n**********************\n\nPart 1:  "
  end
end

Day7.run()
