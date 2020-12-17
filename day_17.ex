defmodule Day17 do
  def run do
    input = parse_input()

    bounds = make_bounds(input)

    grid_1 = make_grid(input)
    grid_2 = make_grid_4d(input)

    part_1 = run_generations(grid_1, bounds, 6)    |> Integer.to_string
    part_2 = run_generations_4d(grid_2, bounds, 6) |> Integer.to_string

    format_output(part_1, part_2)
    |> IO.puts
  end

  ########  Part 1  ########

  def count_neighbors({x, y, z}, grid) do
    Enum.count(
      neighborhood({x, y, z}),
      &MapSet.member?(grid, &1))
  end

  def make_grid(input, x \\ 1, y \\ 1, done \\ MapSet.new())
  def make_grid([[]], _, _, done), do: done
  def make_grid([[] | next_row], _x, y, done) do
    make_grid(next_row, 1, y + 1, done)
  end
  def make_grid([["." | t] | next_row], x, y, done) do
    make_grid([t | next_row], x + 1, y, done)
  end
  def make_grid([["#" | t] | next_row], x, y, done) do
    make_grid([t | next_row], x + 1, y, MapSet.put(done, {x, y, 1}))
  end

  def run_generations(active_grid, _, 0), do: MapSet.size(active_grid)
  def run_generations(active_grid, bounds, count) do
    new_bounds =
      bounds
      |> Map.update!(:min_x, &(&1 - 1))
      |> Map.update!(:min_y, &(&1 - 1))
      |> Map.update!(:min_z, &(&1 - 1))
      |> Map.update!(:max_x, &(&1 + 1))
      |> Map.update!(:max_y, &(&1 + 1))
      |> Map.update!(:max_z, &(&1 + 1))

    new_grid = next_gen(active_grid, new_bounds)

    run_generations(new_grid, new_bounds, count - 1)
  end

  def next_gen(active_grid, bounds) do
    Enum.reduce(
      full_grid(bounds),
      MapSet.new(),
      fn coord, acc ->
        active_self? = MapSet.member?(active_grid, coord)
        active_neighbors = count_neighbors(coord, active_grid)

        case {active_self?, active_neighbors} do
          {true, 2} -> MapSet.put(acc, coord)
          {_, 3}    -> MapSet.put(acc, coord)
          _         -> acc
        end
      end)
  end

  def full_grid(bounds) do
    for x <- bounds[:min_x]..bounds[:max_x],
        y <- bounds[:min_y]..bounds[:max_y],
        z <- bounds[:min_z]..bounds[:max_z] do
      {x, y, z}
    end
  end

  def neighborhood({x, y, z}) do
    for nx <- (x - 1)..(x + 1),
        ny <- (y - 1)..(y + 1),
        nz <- (z - 1)..(z + 1),
        {x, y, z} != {nx, ny, nz} do
      {nx, ny, nz}
    end
  end

  ########  Part 2  ########

  def count_neighbors_4d({x, y, z, w}, grid) do
    Enum.count(
      neighborhood_4d({x, y, z, w}),
      &MapSet.member?(grid, &1))
  end

  def neighborhood_4d({x, y, z, w}) do
    for nx <- (x - 1)..(x + 1),
        ny <- (y - 1)..(y + 1),
        nz <- (z - 1)..(z + 1),
        nw <- (w - 1)..(w + 1),
        {x, y, z, w} != {nx, ny, nz, nw} do
      {nx, ny, nz, nw}
    end
  end

  def make_grid_4d(input, x \\ 1, y \\ 1, done \\ MapSet.new())
  def make_grid_4d([[]], _, _, done), do: done
  def make_grid_4d([[] | next_row], _x, y, done) do
    make_grid_4d(next_row, 1, y + 1, done)
  end
  def make_grid_4d([["." | t] | next_row], x, y, done) do
    make_grid_4d([t | next_row], x + 1, y, done)
  end
  def make_grid_4d([["#" | t] | next_row], x, y, done) do
    make_grid_4d([t | next_row], x + 1, y, MapSet.put(done, {x, y, 1, 1}))
  end

  def full_grid_4d(bounds) do
    for x <- bounds[:min_x]..bounds[:max_x],
        y <- bounds[:min_y]..bounds[:max_y],
        z <- bounds[:min_z]..bounds[:max_z],
        w <- bounds[:min_w]..bounds[:max_w] do
      {x, y, z, w}
    end
  end

  def next_gen_4d(active_grid, bounds) do
    Enum.reduce(
      full_grid_4d(bounds),
      MapSet.new(),
      fn coord, acc ->
        active_self? = MapSet.member?(active_grid, coord)
        active_neighbors = count_neighbors_4d(coord, active_grid)

        case {active_self?, active_neighbors} do
          {true, 2} -> MapSet.put(acc, coord)
          {_, 3}    -> MapSet.put(acc, coord)
          _         -> acc
        end
      end)
  end

  def run_generations_4d(active_grid, _, 0), do: MapSet.size(active_grid)
  def run_generations_4d(active_grid, bounds, count) do
    new_bounds =
      bounds
      |> Map.update!(:min_x, &(&1 - 1))
      |> Map.update!(:min_y, &(&1 - 1))
      |> Map.update!(:min_z, &(&1 - 1))
      |> Map.update!(:min_w, &(&1 - 1))
      |> Map.update!(:max_x, &(&1 + 1))
      |> Map.update!(:max_y, &(&1 + 1))
      |> Map.update!(:max_z, &(&1 + 1))
      |> Map.update!(:max_w, &(&1 + 1))

    new_grid = next_gen_4d(active_grid, new_bounds)

    run_generations_4d(new_grid, new_bounds, count - 1)
  end

  ########  Shared functions  ########

  def parse_input do
    File.read!("day17input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.reverse
  end

  def make_bounds(input) do
    %{
      min_x: 1,
      min_y: 1,
      min_z: 1,
      min_w: 1,
      max_y: length(input),
      max_x: length(hd(input)),
      max_z: 1,
      max_w: 1
    }
  end

  defp format_output(part_1, part_2) do
    "\n***********************\nADVENT OF CODE - DAY 17" <>
      "\n***********************\n\nPart 1:  " <>
      part_1 <> "\n\nPart 2:  " <> part_2 <> "\n"
  end
end

Day17.run()
