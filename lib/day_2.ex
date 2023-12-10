defmodule Day2 do
  def test_input do
    """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """
  end

  @max %{
    "r" => 12,
    "g" => 13,
    "b" => 14
  }

  def solve_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.map(fn {game, id} ->
      Regex.scan(~r/(\d*) ([r|g|b])/, game, capture: :all_but_first)
      |> Enum.all?(fn [count, colour] -> String.to_integer(count) <= @max[colour] end)
      |> case do
        true -> id
        false -> 0
      end
    end)
    |> Enum.sum()
  end

  def solve_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn game ->
      Regex.scan(~r/(\d*) ([r|g|b])/, game, capture: :all_but_first)
      |> Enum.group_by(fn [_, colour] -> colour end, fn [count, _] -> String.to_integer(count) end)
      |> Enum.map(fn {_colour, counts} -> Enum.max(counts) end)
      |> Enum.product()
    end)
    |> Enum.sum()
  end
end

fn ->
  8 = Day2.solve_1(Day2.test_input()) |> IO.inspect(label: "2.1 TEST")
  Day2.solve_1(Api.get_input(2)) |> IO.inspect(label: "2.1")

  2286 = Day2.solve_2(Day2.test_input()) |> IO.inspect(label: "2.2 TEST")
  Day2.solve_2(Api.get_input(2)) |> IO.inspect(label: "2.2")
end
