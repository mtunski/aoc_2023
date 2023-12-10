defmodule Day1 do
  def test_input do
    """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """
  end

  def solve_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      numbers = Regex.scan(~r/[1-9]/, line)
      first = List.first(numbers)
      last = List.last(numbers)
      String.to_integer("#{first}#{last}")
    end)
    |> Enum.sum()
  end

  def test_input_2 do
    """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """
  end

  @strings_to_numbers %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  defp string_to_number(string), do: @strings_to_numbers[string] || string

  def solve_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      regex = ~r/(?=([1-9]|#{@strings_to_numbers |> Map.keys() |> Enum.join("|")}))/
      numbers = regex |> Regex.scan(line, capture: :all_but_first) |> List.flatten()
      first = numbers |> List.first() |> string_to_number()
      last = numbers |> List.last() |> string_to_number()
      String.to_integer("#{first}#{last}")
    end)
    |> Enum.sum()
  end
end

fn ->
  142 = Day1.solve_1(Day1.test_input()) |> IO.inspect(label: "1.1 TEST")
  Day1.solve_1(Api.get_input(1)) |> IO.inspect(label: "1.1")

  281 = Day1.solve_2(Day1.test_input_2()) |> IO.inspect(label: "1.2 TEST")

  443 =
    Day1.solve_2(Day1.test_input_2() <> "\nsevenine" <> "\neighthree")
    |> IO.inspect(label: "1.2 TEST 2")

  Day1.solve_2(Api.get_input(1)) |> IO.inspect(label: "1.2")
end
