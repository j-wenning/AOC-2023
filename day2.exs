defmodule Game do
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&valid_game?/1)
    |> Enum.map(&get_id/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  defp parse_line(input) do
    [gameTag, data] = String.split(input, ": ")
    [_, id] = String.split(gameTag, " ")
    {parse_int(id), parse_game_data(data)}
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
    %{:count => parse_int(count), :color => String.to_atom(color)}
  end

  defp parse_int(str) do
    {i, _} = Integer.parse(str)
    i
  end

  defp valid_game?({_, game_data}) do
    game_data
    |> Enum.find(fn round -> Enum.find(round, &invalid_block?/1) end) == nil
  end

  @max_red 12
  @max_blue 14
  @max_green 13
  defp invalid_block?(block) do
    case block.color do
      :red -> block.count > @max_red
      :blue -> block.count > @max_blue
      :green -> block.count > @max_green
    end
  end

  defp get_id({id, _}) do
    id
  end
end
