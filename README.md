# Advent of Code 2023

My solutions for this year's edition of AoC, written in Elixir.

Prereqs: [devbox](https://www.jetpack.io/devbox/), [direnv](https://direnv.net/)

1. `cp .envrc.sample .envrc`
1. Set _AOC_SESSION_ variable in _.envrc_
1. `direnv allow`
1. `devbox install`
1. `mix do local.rebar --force, local.hex --force && mix escript.install hex livebook`
1. `livebook server`
1. Import `notebook.livemd` into [Livebook](https://livebook.dev/)
1. Run setup block
1. Run task blocks
