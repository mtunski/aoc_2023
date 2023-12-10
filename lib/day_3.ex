defmodule Day3 do
  def test_input do
    """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """
  end

  def solve_1(input) do
    [{map_width, _}] = Regex.run(~r/\n/, input, return: :index)

    parsed_input = String.replace(input, "\n", "")

    parsed_input
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({"", [], []}, fn {char, idx}, {number, indices, numbers} ->
      if char =~ ~r/\d/ do
        {number <> char, indices ++ [idx], numbers}
      else
        line = ceil(idx / map_width) - 1

        indices
        |> Enum.flat_map(fn index ->
          prev_line = [index - map_width - 1, index - map_width, index - map_width + 1]
          prev_line_range = ((line - 1) * map_width)..((line - 1) * map_width + map_width - 1)

          this_line = [index - 1, index + 1]
          this_line_range = (line * map_width)..(line * map_width + map_width - 1)

          next_line = [index + map_width - 1, index + map_width, index + map_width + 1]
          next_line_range = ((line + 1) * map_width)..((line + 1) * map_width + map_width - 1)

          Enum.filter(prev_line, &(&1 in prev_line_range and &1 > 0)) ++
            Enum.filter(this_line, &(&1 in this_line_range)) ++
            Enum.filter(next_line, &(&1 in next_line_range))
        end)
        |> Enum.any?(&(String.at(parsed_input, &1) in ~w/@ # $ % & * + - = \//))
        |> case do
          true ->
            # IO.inspect(number)
            {"", [], [String.to_integer(number) | numbers]}

          _ ->
            {"", [], numbers}
        end
      end
    end)
    |> then(fn {_, _, numbers} ->
      Enum.sum(numbers)
    end)
  end

  def solve_2(input) do
    [{map_width, _}] = Regex.run(~r/\n/, input, return: :index)

    parsed_input = String.replace(input, "\n", "")

    parsed_input
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({"", [], %{}}, fn {char, idx}, {number, indices, numbers} ->
      if char =~ ~r/\d/ do
        {number <> char, indices ++ [idx], numbers}
      else
        line = ceil(idx / map_width) - 1

        indices
        |> Enum.flat_map(fn index ->
          prev_line = [index - map_width - 1, index - map_width, index - map_width + 1]
          prev_line_range = ((line - 1) * map_width)..((line - 1) * map_width + map_width - 1)

          this_line = [index - 1, index + 1]
          this_line_range = (line * map_width)..(line * map_width + map_width - 1)

          next_line = [index + map_width - 1, index + map_width, index + map_width + 1]
          next_line_range = ((line + 1) * map_width)..((line + 1) * map_width + map_width - 1)

          Enum.filter(prev_line, &(&1 in prev_line_range and &1 > 0)) ++
            Enum.filter(this_line, &(&1 in this_line_range)) ++
            Enum.filter(next_line, &(&1 in next_line_range))
        end)
        |> Enum.find(&(String.at(parsed_input, &1) == "*"))
        |> case do
          idx when is_number(idx) ->
            {"", [],
             Map.update(
               numbers,
               idx,
               [String.to_integer(number)],
               &[String.to_integer(number) | &1]
             )}

          _ ->
            {"", [], numbers}
        end
      end
    end)
    |> then(fn {_, _, numbers} ->
      numbers
      |> Enum.filter(fn {_, v} -> length(v) == 2 end)
      |> Enum.map(fn {_, v} -> Enum.product(v) end)
      |> Enum.sum()
    end)
  end
end

4361 = Day3.solve_1(Day3.test_input()) |> IO.inspect(label: "3.1 TEST")
Day3.solve_1(Api.get_input(3)) |> IO.inspect(label: "3.1")

467_835 = Day3.solve_2(Day3.test_input()) |> IO.inspect(label: "3.2 TEST")
Day3.solve_2(Api.get_input(3)) |> IO.inspect(label: "3.2")
