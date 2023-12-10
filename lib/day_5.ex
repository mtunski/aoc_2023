defmodule Day5 do
  def test_input,
    do: """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

  def solve1(input) do
    [seeds | map_groups] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&(Regex.scan(~r/\b\d+\b/, &1) |> Enum.map(fn [a] -> String.to_integer(a) end)))

    map_groups = Enum.map(map_groups, &Enum.chunk_every(&1, 3))

    seeds
    |> Enum.map(fn seed ->
      Enum.reduce(map_groups, seed, fn maps, current_range ->
        Enum.reduce_while(maps, current_range, fn map, current_value ->
          [dest, src, count] = map

          if src <= current_value and current_value < src + count do
            {:halt, dest + current_value - src}
          else
            {:cont, current_value}
          end
        end)
      end)
    end)
    |> Enum.min()
  end

  def solve2(input) do
    [seeds | map_groups] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&(Regex.scan(~r/\b\d+\b/, &1) |> Enum.map(fn [a] -> String.to_integer(a) end)))

    seeds_ranges =
      Enum.chunk_every(seeds, 2)
      |> Enum.map(fn [start, count] -> start..(start + count - 1) end)

    mapping_groups =
      Enum.map(map_groups, fn group ->
        Enum.chunk_every(group, 3)
        |> Enum.map(fn [dest, src, count] ->
          {src..(src + count - 1), dest..(dest + count - 1)}
        end)
      end)

    for range <- seeds_ranges do
      for mapping_group <- mapping_groups, reduce: [range] do
        group_check_ranges ->
          {unmapped, mapped} =
            for mapping <- mapping_group, reduce: {group_check_ranges, []} do
              {check_ranges, mapped_ranges} ->
                for check_range <- check_ranges, reduce: {check_ranges, mapped_ranges} do
                  {check_ranges, mapped_ranges} ->
                    cr_s..cr_e = check_range
                    {tr_s..tr_e, mr_s.._} = mapping

                    max(cr_s, tr_s)..min(cr_e, tr_e)
                    |> case do
                      # no overlap:
                      _.._//-1 ->
                        {check_ranges, mapped_ranges}

                      # overlap:
                      or_s..or_e ->
                        offset = mr_s - tr_s

                        {
                          List.flatten(
                            [
                              if(cr_s < or_s, do: [cr_s..(or_s - 1)], else: []),
                              if(cr_e > or_e, do: [(or_e + 1)..cr_e], else: [])
                            ] ++ (check_ranges -- [check_range])
                          ),
                          [(or_s + offset)..(or_e + offset) | mapped_ranges]
                        }
                    end
                end
            end

          unmapped ++ mapped
      end
    end
    |> List.flatten()
    |> Enum.map(fn r_s.._ ->
      r_s
    end)
    |> Enum.min()
  end
end

fn ->
  Day5.solve1(Day5.test_input()) |> IO.inspect(label: "TEST 5.1")
  Day5.solve1(Api.get_input(5)) |> IO.inspect(label: "5.1")

  Day5.solve2(Day5.test_input()) |> IO.inspect(label: "TEST 5.2")
  Day5.solve2(Api.get_input(5)) |> IO.inspect(label: "5.2")
end
