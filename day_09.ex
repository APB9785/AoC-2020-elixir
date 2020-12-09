defmodule Day9 do
  def run do
    input = parse_input()

    target = main_1(input)

    IO.puts(header() <> Integer.to_string(target))

    IO.puts("\nPart 2:  " <> main_2(input, target) <> "\n")
  end

  def parse_input do
    File.read!("day9input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def main_1(input) do
    loop_1(Enum.take(input, 25), Enum.drop(input, 25))
  end

  def loop_1(buffer, [h | todo]) do
    if valid?(h, buffer) do
      new_buffer = Enum.drop(buffer, 1) ++ [h]
      loop_1(new_buffer, todo)
    else
      h
    end
  end

  def main_2(input, target) do
    case loop_2(input, target) do
      {:found, list} ->
        Enum.min(list) + Enum.max(list) |> Integer.to_string

      {:not_found} ->
        main_2(tl(input), target)
    end
  end

  def loop_2(input, target, done \\ [], i \\ 0)
  def loop_2(_, target, done, i) when target == i, do: {:found, done}
  def loop_2(_, target, _done, i) when i > target, do: {:not_found}
  def loop_2([h | t], target, done, i) do
    loop_2(t, target, [h | done], i + h)
  end

  def valid?(_value, []), do: false
  def valid?(value, [h | t]) do
    if (value - h) in t do
      true
    else
      valid?(value, t)
    end
  end

  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 9" <>
      "\n**********************\n\nPart 1:  "
  end
end

Day9.run()
