defmodule Day1 do

  def run() do
    input = parse_input()

    IO.puts(header() <> part_1(input))

    IO.puts("\nPart 2:  " <> part_2(input) <> "\n")
  end


  defp part_1(n_list) do
    find_complements(n_list) |> Integer.to_string
  end


  defp part_2(n_list) do
    start_val = hd(n_list)

    case find_complements(tl(n_list), (2020 - start_val)) do
      "none" -> tl(n_list) |> part_2
      x      -> x * start_val |> Integer.to_string
    end
  end


  defp find_complements(n_list, total \\ 2020)
  defp find_complements([], _), do: "none"
  defp find_complements(n_list, total) do
    target = total - hd(n_list)

    if target in tl(n_list) do
      hd(n_list) * target
    else
      tl(n_list) |> find_complements(total)
    end

  end


  defp parse_input() do
    File.read!("day1input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end


  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 1" <>
      "\n**********************\n\nPart 1:  "
  end
end


Day1.run()
