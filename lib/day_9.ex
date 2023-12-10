defmodule Day9 do
  def test_input,
    do: """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

  def nextval(history, prev) do
    if List.last(history) == 0 do
      0
    else
      next_seq =
        history
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce([], fn [curr, next], acc ->
          [next - curr | acc]
        end)
        |> Enum.reverse()

      nextval(next_seq, List.last(next_seq))
    end + prev
  end

  def solve_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn history ->
      String.split(history, " ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce(0, fn history, sum ->
      sum + nextval(history, List.last(history))
    end)
  end

  def nextval_backwards(history, prev) do
    prev -
      if List.last(history) == 0 do
        0
      else
        next_seq =
          history
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.reduce([], fn [curr, next], acc ->
            [next - curr | acc]
          end)
          |> Enum.reverse()

        nextval_backwards(next_seq, List.first(next_seq))
      end
  end

  def solve_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn history ->
      String.split(history, " ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce(0, fn history, sum ->
      sum + nextval_backwards(history, List.first(history))
    end)
  end
end

fn ->
  114 = Day9.solve_1(Day9.test_input()) |> IO.inspect(label: "9.1 TEST")
  Day9.solve_1(Api.get_input(9)) |> IO.inspect(label: "9.1")

  2 = Day9.solve_2(Day9.test_input()) |> IO.inspect(label: "9.2 TEST")
  Day9.solve_2(Api.get_input(9)) |> IO.inspect(label: "9.2")
end
