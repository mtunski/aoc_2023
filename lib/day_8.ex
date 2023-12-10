defmodule Day8 do
  def test_input_1,
    do: """
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """

  def test_input_2,
    do: """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

  def solve_1(input) do
    {directions, map} =
      input
      |> String.split("\n\n", trim: true)
      |> then(fn [directions, map] ->
        {
          String.split(directions, "", trim: true),
          Regex.scan(~r/\b\w+\b/, map)
          |> Enum.chunk_every(3)
          |> Enum.reduce(%{}, fn [[dest], [left], [right]], acc ->
            Map.put(acc, dest, %{"L" => left, "R" => right})
          end)
        }
      end)

    go(directions, map, "AAA", 0, version: 1)
  end

  defp go(directions, map, node, step, version: version) do
    direction = Enum.at(directions, rem(step, length(directions)))
    next_node = get_in(map, [node, direction])

    stop_node_cond = if version == 1, do: node == "ZZZ", else: String.ends_with?(node, "Z")
    if stop_node_cond, do: step, else: go(directions, map, next_node, step + 1, version: version)
  end

  def test_input3,
    do: """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

  def solve_2(input) do
    {directions, map} =
      input
      |> String.split("\n\n", trim: true)
      |> then(fn [directions, map] ->
        {
          String.split(directions, "", trim: true),
          Regex.scan(~r/\b\w+\b/, map)
          |> Enum.chunk_every(3)
          |> Enum.reduce(%{}, fn [[dest], [left], [right]], acc ->
            Map.put(acc, dest, %{"L" => left, "R" => right})
          end)
        }
      end)

    map
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.reduce([], fn node, acc ->
      [go(directions, map, node, 0, version: 2) | acc]
    end)
    |> Enum.reduce(1, fn n, lcd ->
      div(n * lcd, Integer.gcd(n, lcd))
    end)
  end
end

fn ->
  2 = Day8.solve_1(Day8.test_input_1()) |> IO.inspect(label: "8.1 TEST")
  6 = Day8.solve_1(Day8.test_input_2()) |> IO.inspect(label: "8.1 TEST")
  Day8.solve_1(Api.get_input(8)) |> IO.inspect(label: "8.1")

  6 = Day8.solve_2(Day8.test_input3()) |> IO.inspect(label: "8.2 TEST")
  Day8.solve_2(Api.get_input(8)) |> IO.inspect(label: "8.2")
end
