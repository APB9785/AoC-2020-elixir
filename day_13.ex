defmodule Day13 do
  def run do
    {eta, buses} = parse_input()

    part_1 = main_1(eta, buses)
    part_2 = main_2(buses)

    format_output(part_1, part_2)
    |> IO.puts
  end

  def parse_input do
    [line_1, line_2] =
      File.read!("day13input.txt")
      |> String.split("\n", trim: true)

    eta = String.to_integer(line_1)
    buses = String.split(line_2, ",")

    {eta, buses}
  end

  def main_1(eta, buses) do
    Enum.reject(buses, &(&1 == "x"))
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(fn x -> {x, x - rem(eta, x)} end)
    |> Enum.min_by(&elem(&1, 1))
    |> (fn {a, b} -> a * b end).()
    |> Integer.to_string
  end

  def main_2(buses) do
    buses
    |> Enum.map(&(if &1 == "x" do "x" else String.to_integer(&1) end))
    |> Enum.with_index
    |> Enum.reduce({0, 1}, &check_bus/2)
    |> elem(0)
    |> Integer.to_string
  end

  # Fast bruteforce using LCM of all past buses
  def check_bus({"x", _}, acc), do: acc
  def check_bus({bus, idx}, {time, offset}) do
    if rem(time + idx, bus) == 0 do
      {time, lcm(offset, bus)}
    else
      check_bus({bus, idx}, {time + offset, offset})
    end
  end

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, Integer.gcd(a, b))

  defp format_output(part_1, part_2) do
    "\n***********************\nADVENT OF CODE - DAY 13" <>
      "\n***********************\n\nPart 1:  " <>
      part_1 <> "\n\nPart 2:  " <> part_2 <> "\n"
  end
end

Day13.run()
