defmodule Day5 do
  def run() do
    input = parse_input()

    IO.puts(header() <> main_1(input))

    IO.puts("\nPart 2:  " <> main_2(input) <> "\n")
  end

  def main_1(input) do
    input
    |> Enum.max_by(&elem(&1, 2))
    |> elem(2)
    |> Integer.to_string
  end

  def main_2(input) do
    input
    |> Enum.map(&elem(&1, 2))
    |> Enum.sort
    |> first_missing
    |> Integer.to_string
  end

  def first_missing([a | [b | rest]]) do
    if b == a + 1 do
      first_missing([b | rest])
    else
      a + 1
    end
  end

  def decode_line(line) do
    {row, col} = String.split_at(line, 7)
    dec_row =
      row
      |> String.replace("F", "0")
      |> String.replace("B", "1")
      |> Integer.parse(2)
      |> elem(0)

    dec_col =
      col
      |> String.replace("L", "0")
      |> String.replace("R", "1")
      |> Integer.parse(2)
      |> elem(0)

    id = dec_row * 8 + dec_col

    {dec_row, dec_col, id}
  end

  def parse_input() do
    File.read!("day5input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&decode_line/1)
  end

  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 5" <>
      "\n**********************\n\nPart 1:  "
  end
end

Day5.run()
