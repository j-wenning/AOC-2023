defmodule Game do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Stream.map(&merge_game/1)
    |> Stream.map(&calc_power/1)
    |> Enum.sum()
    |> dbg
  end

  defp parse_line(input) do
    [_, data] = String.split(input, ": ")
    parse_game_data(data)
  end

  defp parse_game_data(str) do
    str
    |> String.split("; ")
    |> Enum.map(&parse_round_data/1)
  end

  defp parse_round_data(str) do
    str
    |> String.split(", ")
    |> Enum.map(&parse_block_data/1)
  end

  defp parse_block_data(str) do
    [count, color] = String.split(str, " ")
    {String.to_atom(color), String.to_integer(count)}
  end

  defp merge_game(game) do
    Enum.reduce(game, %{}, &merge_round/2)
  end

  defp merge_round(round, acc) do
    Enum.reduce(round, acc, &merge_block/2)
  end

  defp merge_block({color, count}, acc) do
    Map.put(acc, color, max(count, Map.get(acc, color, 0)))
  end

  defp calc_power(merged) do
    Map.get(merged, :red, 1) * Map.get(merged, :blue, 1) * Map.get(merged, :green, 1)
  end
end
