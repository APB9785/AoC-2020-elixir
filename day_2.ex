defmodule Day2 do
  def run() do
    input = parse_input()

    IO.puts(header() <> main(input, :part_1))

    IO.puts("\nPart 2:  " <> main(input, :part_2) <> "\n")
  end

  defp main(input, part) do
    input
    |> Enum.count(&pass_ok?(&1, part))
    |> Integer.to_string()
  end

  defp pass_ok?({pass, a, b, letter}, :part_1) do
    actual_qty = String.graphemes(pass) |> Enum.count(fn x -> x == letter end)

    actual_qty in a..b
  end

  defp pass_ok?({pass, a, b, letter}, :part_2) do
    (String.at(pass, a - 1) == letter) != (String.at(pass, b - 1) == letter)
  end

  defp parse_input() do
    File.read!("day2input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [reqs, pass] = String.split(line, ": ")
    [qty_range, letter] = String.split(reqs, " ")
    [a, b] = String.split(qty_range, "-") |> Enum.map(&String.to_integer/1)

    {pass, a, b, letter}
  end

  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 2" <>
      "\n**********************\n\nPart 1:  "
  end
end

Day2.run()
