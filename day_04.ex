defmodule Day4 do
  def run() do
    input = parse_input()

    IO.puts(header() <> main_1(input))

    IO.puts("\nPart 2:  " <> main_2(input) <> "\n")
  end

  defp main_1(input) do
    input
    |> Enum.filter(&check_fields/1)
    |> length
    |> Integer.to_string
  end

  defp main_2(input) do
    input
    |> Enum.filter(&check_fields/1)
    |> Enum.filter(&check_values/1)
    |> length
    |> Integer.to_string
  end

  defp parse_input() do
    File.read!("day4input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reject(&(&1 == []))
    |> Enum.map(&hd/1)
    |> Enum.map(&tl/1)
  end

  defp check_fields(pass) do
    if length(pass) == 8 do
      true
    else
      pass
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.all?(fn i -> hd(i) != "cid" end)
    end
  end

  defp check_values(pass) do
    pass
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.all?(fn [k, v] -> reqs_met?(k, v) end)
  end

  defp reqs_met?(field, value) do
    case field do
      "byr" ->
        if String.length(value) == 4 do
          n = String.to_integer(value)
          (n >= 1920) and (n <= 2002)
        else
          false
        end

      "iyr" ->
        if String.length(value) == 4 do
          n = String.to_integer(value)
          (n >= 2010) and (n <= 2020)
        else
          false
        end

      "eyr" ->
        if String.length(value) == 4 do
          n = String.to_integer(value)
          (n >= 2020) and (n <= 2030)
        else
          false
        end

      "hgt" ->
        case Integer.parse(value) do
          {_n, ""} ->
            false
          {n, "in"} ->
            (n >= 59) and (n <= 76)
          {n, "cm"} ->
            (n >= 150) and (n <= 193)
        end

      "hcl" ->
        (String.length(value) == 7) and (String.at(value, 0) == "#")

      "ecl" ->
        value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

      "pid" ->
        (String.length(value) == 9) and (elem(Integer.parse(value), 1) == "")

      "cid" ->
        true
    end
  end

  defp parse_line(line) do
    Regex.scan(
      ~r/(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s(\S+)\s?(\S+)?/, line)
  end

  defp header() do
    "\n**********************\nADVENT OF CODE - DAY 4" <>
      "\n**********************\n\nPart 1:  "
  end
end

Day4.run()
