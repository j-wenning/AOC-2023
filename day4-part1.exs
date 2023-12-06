defmodule Scratch do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Stream.map(&aggregate_points/1)
    |> Enum.sum()
  end

  defp parse_line(line) do
    [card_id, data] = line |> String.split(":", trim: true)
    [_, card_id] = card_id |> String.split(" ", trim: true)
    [winning_nums, actual_nums] = data |> String.split(" | ", trim: true)

    card_id = card_id |> String.to_integer()

    winning_nums =
      winning_nums
      |> String.split(" ", trim: true)
      |> Stream.map(&String.to_integer/1)
      |> MapSet.new()

    actual_nums = actual_nums |> String.split(" ", trim: true) |> Stream.map(&String.to_integer/1)

    {card_id, winning_nums, actual_nums}
  end

  defp aggregate_points({_card_id, winning_nums, actual_nums}) do
    pow = actual_nums |> Enum.count(fn num -> winning_nums |> MapSet.member?(num) end)

    if pow > 0,
      do: 2 ** (pow - 1),
      else: 0
  end
end
