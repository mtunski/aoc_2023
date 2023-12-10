defmodule Day7 do
  def test_input,
    do: """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

  defp strength("A", _), do: 14
  defp strength("K", _), do: 13
  defp strength("Q", _), do: 12
  defp strength("J", jokers: true), do: 1
  defp strength("J", _), do: 11
  defp strength("T", _), do: 10
  defp strength(card, _), do: String.to_integer(card)

  defp type(cards, jokers: jokers) do
    j_card = if jokers, do: pick_joker_card(cards), else: "J"

    cards
    |> Enum.frequencies_by(fn
      "J" -> j_card
      card -> card
    end)
    |> Enum.map(fn {_, freq} -> freq end)
    |> Enum.sort(&Kernel.>/2)
    |> case do
      [5] -> 7
      [4, 1] -> 6
      [3, 2] -> 5
      [3, 1, 1] -> 4
      [2, 2, 1] -> 3
      [2, 1, 1, 1] -> 2
      _ -> 1
    end
  end

  defp pick_joker_card(cards) do
    cards
    |> Enum.frequencies()
    |> Enum.max_by(fn
      {"J", _freq} -> 0
      {_card, freq} -> freq
    end)
    |> elem(0)
  end

  defp strengths(cards, jokers: jokers), do: Enum.map(cards, &strength(&1, jokers: jokers))

  defp play(hand, jokers: jokers) do
    cards = String.split(hand, "", trim: true)
    {type(cards, jokers: jokers), strengths(cards, jokers: jokers)}
  end

  def solve(input, jokers: jokers) do
    Regex.scan(~r/(\w+) (\d+)/, input, capture: :all_but_first)
    |> Enum.reduce([], fn [hand, bid], acc ->
      [{play(hand, jokers: jokers), String.to_integer(bid)} | acc]
    end)
    |> Enum.sort_by(fn {hand, _bid} -> hand end, :asc)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, bid}, multiplier}, sum ->
      sum + bid * multiplier
    end)
  end
end

6440 = Day7.solve(Day7.test_input(), jokers: false) |> IO.inspect(label: "7.1 TEST")
Day7.solve(Api.get_input(7), jokers: false) |> IO.inspect(label: "7.1")

5905 = Day7.solve(Day7.test_input(), jokers: true) |> IO.inspect(label: "7.2 TEST")
Day7.solve(Api.get_input(7), jokers: true) |> IO.inspect(label: "7.2")
