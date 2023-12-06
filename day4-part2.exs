defmodule Scratch do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Stream.map(&count_matches/1)
    |> aggregate_points()
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

  defp count_matches({_card_id, winning_nums, actual_nums}) do
    actual_nums |> Enum.count(&MapSet.member?(winning_nums, &1))
  end

  defp aggregate_points(list) do
    list
    |> Enum.reduce({0, []}, fn bonus_cards, {sum, bonus_list} ->
      card_count = 1 + (bonus_list |> Enum.map(&elem(&1, 0)) |> Enum.sum())

      bonus_list =
        bonus_list
        |> Stream.map(fn {count, age} -> {count, age - 1} end)
        |> Enum.filter(fn {_, age} -> age > 0 end)

      bonus_list =
        if bonus_cards > 0,
          do: [{card_count, bonus_cards} | bonus_list],
          else: bonus_list

      {sum + card_count, bonus_list}
    end)
    |> elem(0)
  end
end
