defmodule Day4 do
  def test_input,
    do: """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

  def solve_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn game, acc ->
      matching_count = count_matches(game)
      floor(acc + 2 ** (matching_count - 1))
    end)
  end

  def solve_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> then(fn cards ->
      cards_counts = 1..length(cards) |> Enum.map(&{&1, 1}) |> Enum.into(%{})

      Enum.reduce(cards, cards_counts, fn {card, idx}, cards_counts ->
        card
        |> count_matches()
        |> case do
          0 ->
            cards_counts

          match_count ->
            Enum.reduce((idx + 1)..(idx + match_count), cards_counts, fn match_idx,
                                                                         cards_counts ->
              Map.put(cards_counts, match_idx, cards_counts[match_idx] + cards_counts[idx])
            end)
        end
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp count_matches(card) do
    card
    |> String.split(":")
    |> List.last()
    |> String.split("|")
    |> Enum.map(&(&1 |> String.split(" ", trim: true) |> MapSet.new()))
    |> then(fn [winning, mine] -> MapSet.intersection(mine, winning) |> MapSet.size() end)
  end
end

fn ->
  13 = Day4.solve_1(Day4.test_input()) |> IO.inspect(label: "4.1 TEST")
  Day4.solve_1(Api.get_input(4)) |> IO.inspect(label: "4.1")

  30 = Day4.solve_2(Day4.test_input()) |> IO.inspect(label: "4.2 TEST")
  Day4.solve_2(Api.get_input(4)) |> IO.inspect(label: "4.2")
end
