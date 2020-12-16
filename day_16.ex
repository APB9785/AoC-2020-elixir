defmodule Day16 do
  def run do
    input = parse_input()

    apv = all_possible_values(input[:rules])

    part_1 = main_1(input, apv)
    part_2 = main_2(input, apv)

    format_output(part_1, part_2)
    |> IO.puts
  end


  def parse_input do
    [rules, my_ticket, nearby_tickets] =
      File.read!("day16input.txt")
      |> String.split("\n\n")

    rules = String.split(rules, "\n")
    rules = Enum.map(rules, &parse_line/1)

    [_, my_ticket] = String.split(my_ticket, "\n")
    my_ticket =
      String.split(my_ticket, ",")
      |> Enum.map(&String.to_integer/1)

    nearby_tickets =
      String.split(nearby_tickets, "\n", trim: true)
      |> tl
      |> Enum.map(fn x ->
           String.split(x, ",")
           |> Enum.map(&String.to_integer/1)
         end)

    %{rules: Enum.into(rules, %{}),
      my_ticket: my_ticket,
      nearby_tickets: nearby_tickets}
  end


  def parse_line(line) do
    [field, values] = String.split(line, ": ")
    values =
      String.split(values, " or ")
      |> Enum.reduce(MapSet.new(), fn x, acc ->
           [a, z] =
             String.split(x, "-")
             |> Enum.map(&String.to_integer/1)
           MapSet.new(a..z)
             |> MapSet.union(acc)
           end)
    {field, values}
  end


  def main_1(%{:nearby_tickets => nearby_tickets}, apv) do
    nearby_tickets
    |> Enum.reduce([], fn x, acc -> acc ++ x end)
    |> Enum.reject(&MapSet.member?(apv, &1))
    |> Enum.sum
    |> Integer.to_string
  end


  def main_2(%{:my_ticket => my_ticket, :nearby_tickets => nearby_tickets,
               :rules => rules}, apv) do
    valid_tickets =
      Enum.filter(nearby_tickets, fn ticket ->
        Enum.all?(ticket, &MapSet.member?(apv, &1))
      end)

    0..(length(my_ticket) - 1)
    |> Enum.reduce(%{}, fn x, acc ->
         vals = Enum.reduce(valid_tickets, [], &(&2 ++ [Enum.at(&1, x)]))
         Map.put(acc, x, match_field(rules, vals)) end)
    |> Enum.into([])
    |> Enum.sort(&(length(elem(&1, 1)) <= length(elem(&2, 1))))
    |> logical_solve
    |> get_departure_indexes
    |> Enum.reduce(1, fn x, acc -> acc * Enum.at(my_ticket, x) end)
    |> Integer.to_string
  end


  def match_field(rules, vals) do
    Map.keys(rules)
    |> Enum.filter(fn key ->
         Enum.all?(vals, &MapSet.member?(rules[key], &1))
       end)
  end


  def logical_solve(list, seen \\ [], done \\ [])
  def logical_solve([], _, done), do: done
  def logical_solve([{idx, fields} | t], seen, done) do
    result = Enum.reject(fields, &(&1 in seen)) |> hd
    logical_solve(t, seen ++ [result], done ++ [{idx, result}])
  end


  def get_departure_indexes(list) do
    list
    |> Enum.filter(fn {_, field} -> field in departure_fields() end)
    |> Enum.map(&elem(&1, 0))
  end


  def all_possible_values(rules) do
    Enum.reduce(rules, MapSet.new(), fn {_, v}, acc -> MapSet.union(acc, v) end)
  end


  def departure_fields do
    [
      "departure track",
      "departure station",
      "departure platform",
      "departure location",
      "departure time",
      "departure date"
    ]
  end


  defp format_output(part_1, part_2) do
    "\n***********************\nADVENT OF CODE - DAY 16" <>
      "\n***********************\n\nPart 1:  " <>
      part_1 <> "\n\nPart 2:  " <> part_2 <> "\n"
  end
end

Day16.run()
