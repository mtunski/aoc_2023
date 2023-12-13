defmodule Day10 do
  def test_input_1,
    do: """
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    """

  def test_input_2,
    do: """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

  def solve_1(input) do
    {map, start, _, _} =
      input
      |> String.split("", trim: true)
      |> Enum.reduce({%{}, {}, 0, 0}, fn tile, {map, start, x, y} ->
        case tile do
          "\n" -> {map, start, 0, y + 1}
          "S" -> {Map.put(map, {x, y}, {tile, false}), {x, y}, x + 1, y}
          _ -> {Map.put(map, {x, y}, {tile, false}), start, x + 1, y}
        end
      end)

    ceil(go(map, start, 0) / 2)
  end

  defp go(map, current_position, step) do
    next_position = get_next_position(map, current_position)

    if(next_position == nil) do
      step
    else
      go(update_map(map, current_position), next_position, step + 1)
    end
  end

  def test_input_3,
    do: """
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """

  def solve_2(input) do
    {map, start, _, _} =
      input
      |> String.split("", trim: true)
      |> Enum.reduce({%{}, {}, 0, 0}, fn tile, {map, start, x, y} ->
        case tile do
          "\n" -> {map, start, 0, y + 1}
          "S" -> {Map.put(map, {x, y}, {tile, false}), {x, y}, x + 1, y}
          _ -> {Map.put(map, {x, y}, {tile, false}), start, x + 1, y}
        end
      end)

    map_with_loop = go(map, start)

    # IO.inspect(map_with_loop[start])
    determine_start_tile(map_with_loop, start) |> IO.inspect()
  end

  defp go(map, current_position) do
    next_position = get_next_position(map, current_position)

    if(next_position == nil) do
      update_map(map, current_position)
    else
      go(update_map(map, current_position), next_position)
    end
  end

  def determine_start_tile(map_with_loop, {x, y}) do
    [{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}]
    |> Enum.map(fn position ->
      case map_with_loop[position] do
        {tile, true} -> tile
        _ -> nil
      end
    end)
    # |> Enum.reject(&is_nil/1)
    |> case do
      ["|", "-" | _] -> "L"
      ["|", "7" | _] -> "L"
      ["|", "J" | _] -> "L"
      #
      ["|", _, "J", _] -> "|"
      ["|", _, "|", _] -> "|"
      ["|", _, "L", _] -> "|"
      #
      ["|", _, _, "F"] -> "J"
      ["|", _, _, "L"] -> "J"
      ["|", _, _, "-"] -> "J"
      #
      [_, _, _, "F"] -> "-"
      [_, _, _, "L"] -> "-"
      [_, _, _, "-"] -> "-"
    end
  end

  defp get_next_position(map, {x, y} = current_position) do
    current_tile = map[current_position]
    # IO.inspect("CURRENT TILE {#{x}, #{y}}: #{current_tile}, GET NEXT POSITION")

    [{{x, y - 1}, :north}, {{x + 1, y}, :east}, {{x, y + 1}, :south}, {{x - 1, y}, :west}]
    |> Enum.reduce_while(nil, fn {next_position, direction}, _ ->
      next_tile = map[next_position]

      if is_valid_next_tile?(current_tile, direction, next_tile) do
        {:halt, next_position}
      else
        {:cont, nil}
      end
    end)
  end

  defp is_valid_next_tile?({current_tile, _}, :north, {next_tile, false})
       when current_tile in ~w(S | J L) and
              next_tile in ~w(| 7 F),
       do: true

  defp is_valid_next_tile?({current_tile, _}, :east, {next_tile, false})
       when current_tile in ~w(S - F L) and
              next_tile in ~w(- 7 J),
       do: true

  defp is_valid_next_tile?({current_tile, _}, :south, {next_tile, false})
       when current_tile in ~w(S | 7 F) and next_tile in ~w(| J L),
       do: true

  defp is_valid_next_tile?({current_tile, _}, :west, {next_tile, false})
       when current_tile in ~w(S - 7 J) and
              next_tile in ~w(- L F),
       do: true

  defp is_valid_next_tile?(_, _, _), do: false

  defp update_map(map, current_position) do
    Map.update!(map, current_position, fn {tile, _} -> {tile, true} end)
  end
end

fn ->
  Day10.solve_1(Day10.test_input_1()) |> IO.inspect(label: "10.1 TEST")
  Day10.solve_1(Day10.test_input_2()) |> IO.inspect(label: "10.1 TEST")

  Day10.solve_1(Api.get_input(10)) |> IO.inspect(label: "10.1")

  Day10.solve_2(Day10.test_input_3()) |> IO.inspect(label: "10.2 TEST")
end
