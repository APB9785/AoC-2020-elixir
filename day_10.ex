defmodule Day10 do
  def run do
    input = parse_input()

    IO.puts(header() <> main_1(input))

    IO.puts("\nPart 2:  " <> main_2(input) <> "\n")
  end

  def parse_input do
    File.read!("day10input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> (fn x -> [(Enum.max(x) + 3) | x] end).()
    |> Enum.sort
  end

  def main_1(input) do
    {_, ones, threes} =
      Enum.reduce(input, {0, 0, 0}, fn x, {last, ones, threes} ->
           case (x - last) do
             1 ->
               {x, ones + 1, threes}
             2 ->
               {x, ones, threes}
             3 ->
               {x, ones, threes + 1}
           end
         end)
    Integer.to_string(ones * threes)
  end

  def main_2(input, cache \\ %{0 => 1}, prev \\ [0], count \\ 1)
  def main_2([], cache, _prev, _count) do
    final_key = Enum.max(Map.keys(cache))

    cache[final_key] |> Integer.to_string
  end
  def main_2([h | t], cache, prev, count) do
    new_prev = Enum.filter(prev, &(h - &1 <= 3))
    new_val = Enum.reduce(1..length(new_prev), 0, &(&2 + cache[count - &1]))
    new_cache = Map.put(cache, count, new_val)

    main_2(t, new_cache, [h | new_prev], count + 1)
  end

  defp header() do
    "\n***********************\nADVENT OF CODE - DAY 10" <>
      "\n***********************\n\nPart 1:  "
  end
end

Day10.run()
