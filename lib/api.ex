defmodule Api do
  use Tesla

  @session System.get_env("AOC_SESSION")

  plug(Tesla.Middleware.BaseUrl, "https://adventofcode.com/2023/day/")
  plug(Tesla.Middleware.Headers, [{"cookie", "session=#{@session}"}])

  def get_input(day) do
    path =
      ".inputs/#{day}"

    case File.read(path) do
      {:ok, input} ->
        input

      _ ->
        {:ok, response} = get("#{day}/input")
        input = response.body

        :ok = File.write(path, input)

        input
    end
  end
end
