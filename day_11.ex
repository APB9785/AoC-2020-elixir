defmodule Day11 do
  def run do
    init_config = parse_input()

    part_1 = main(init_config, 4, :adjacent)
    part_2 = main(init_config, 5, :visible)

    format_output(part_1, part_2)
    |> IO.puts
  end

  defp parse_input do
    File.read!("day11input.txt")
    |> String.graphemes
    |> make_grid
  end

  defp make_grid(input, row \\ 0, col \\ 0, grid \\ %{})
  defp make_grid(["\n"], _row, _col, grid), do: grid
  defp make_grid(["\n" | t], row, _col, grid) do
    make_grid(t, row + 1, 0, grid)
  end
  defp make_grid([h | t], row, col, grid) do
    new_grid = Map.put(grid, {row, col}, h)

    make_grid(t, row, col + 1, new_grid)
  end

  # Runs until the grid converges to a static state.
  defp main(grid, tolerance, search_type) do
    case next_gen(grid, tolerance, search_type) do
      {new_grid, 0} ->
        Enum.count(new_grid, fn {_k, v} -> v == "#" end)
        |> Integer.to_string

      {new_grid, _changes} ->
        main(new_grid, tolerance, search_type)
    end
  end

  # Runs one generation for the entire grid
  defp next_gen(grid, tolerance, search_type) do
    Enum.reduce(grid, {%{}, 0}, fn cell, {acc_grid, acc_changes} ->
      {coords, new_cell, change} = evolve(grid, cell, tolerance, search_type)

      {Map.put(acc_grid, coords, new_cell), acc_changes + change}
    end)
  end

  # One generation for just one cell
  defp evolve(grid, {coords, cell_state}, tolerance, search_type) do
    case cell_state do
      "." ->
        {coords, ".", 0}
      "#" ->
        if active_neighbors(grid, coords, search_type) >= tolerance do
          {coords, "L", 1}
        else
          {coords, "#", 0}
        end
      "L" ->
        if active_neighbors(grid, coords, search_type) == 0 do
          {coords, "#", 1}
        else
          {coords, "L", 0}
        end
    end
  end

  # For part 1: standard Moore neighborhood
  defp active_neighbors(grid, {row, col}, :adjacent) do
    neighbors_list(row, col)
    |> Enum.count(fn coord -> grid[coord] == "#" end)
  end

  # For part 2
  defp active_neighbors(grid, {row, col}, :visible) do
    Enum.reduce(neighbors_list(row, col), 0, fn {r, c}, acc ->
      slope = {r - row, c - col}

      acc + line_of_sight(grid, {row, col}, slope)
    end)
  end

  defp line_of_sight(grid, {row, col}, {d_r, d_c}) do
    new_coords = {row + d_r, col + d_c}
    case grid[new_coords] do
      nil -> 0
      "L" -> 0
      "#" -> 1
      "." -> line_of_sight(grid, new_coords, {d_r, d_c})
    end
  end

  defp neighbors_list(row, col) do
    [
      {row + 1, col + 1},
      {row + 1, col},
      {row + 1, col - 1},
      {row - 1, col + 1},
      {row - 1, col},
      {row - 1, col - 1},
      {row, col + 1},
      {row, col - 1}
    ]
  end

  defp format_output(part_1, part_2) do
    "\n***********************\nADVENT OF CODE - DAY 11" <>
      "\n***********************\n\nPart 1:  " <>
      part_1 <> "\n\nPart 2:  " <> part_2 <> "\n"
  end
end

Day11.run()
