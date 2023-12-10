defmodule MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc_2023,
      version: "1.0.0",
      deps: deps()
    ]
  end

  defp deps do
    [{:tesla, "~> 1.8"}]
  end
end
