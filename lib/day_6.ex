defmodule Day6 do
  def test_input,
    do: """
    Time:      7  15   30
    Distance:  9  40  200
    """

  def solve_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(~r/\b\d+\b/
        |> Regex.scan(&1)
        |> Enum.map(fn match -> match |> hd() |> String.to_integer() end))
    )
    |> Enum.zip()
    |> Enum.reduce([], fn {time, record_distance}, winning_counts ->
      [
        Enum.reduce(1..(time - 1), 0, fn hold_time, winning_count ->
          distance = hold_time * (time - hold_time)
          if distance > record_distance, do: winning_count + 1, else: winning_count
        end)
        | winning_counts
      ]
    end)
    |> Enum.product()
  end

  def solve_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(~r/\b\d+\b/
        |> Regex.scan(&1)
        |> Enum.map(fn match -> hd(match) end)
        |> Enum.join()
        |> String.to_integer())
    )
    |> then(fn [time, record_distance] ->
      Enum.reduce(1..(time - 1), 0, fn hold_time, winning_count ->
        distance = hold_time * (time - hold_time)
        if distance > record_distance, do: winning_count + 1, else: winning_count
      end)
    end)
  end
end

fn ->
  288 = Day6.solve_1(Day6.test_input()) |> IO.inspect(label: "6.1 TEST")
  Day6.solve_1(Api.get_input(6)) |> IO.inspect(label: "6.1")

  71503 = Day6.solve_2(Day6.test_input()) |> IO.inspect(label: "6.2 TEST")
  Day6.solve_2(Api.get_input(6)) |> IO.inspect(label: "6.2")
end
