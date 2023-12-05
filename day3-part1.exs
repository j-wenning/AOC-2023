defmodule Schematic do
  def parse_input(input) do
    %{:part_nums => part_nums, :adjacent_coords => adjacent_coords} =
      input
      |> String.split("\n", trim: true)
      |> Stream.with_index()
      |> Enum.reduce(%{:part_nums => [], :adjacent_coords => []}, &parse_line/2)

    adjacent_coords =
      adjacent_coords
      |> Enum.flat_map(fn {_sym, coords} -> coords end)
      |> MapSet.new()

    part_nums
    |> Stream.filter(fn {_num, coords} ->
      Enum.any?(coords, fn coord -> MapSet.member?(adjacent_coords, coord) end)
    end)
    |> Stream.map(fn {num, _coords} -> String.to_integer(num) end)
    |> Enum.sum()
  end

  @digit_re ~r/\d+/
  @symbol_re ~r/[`~!@#$&%^*()\-+=_{}\[\]'";\/\\,]/
  defp parse_line({line, y}, acc) do
    acc
    |> Map.put(
      :part_nums,
      Enum.zip(
        Regex.scan(@digit_re, line, return: :binary) |> List.flatten(),
        Regex.scan(@digit_re, line, return: :index)
        |> Enum.map(fn [{x, len}] ->
          x..(x + len - 1)
          |> Enum.map(&{&1, y})
        end)
      ) ++ acc[:part_nums]
    )
    |> Map.put(
      :adjacent_coords,
      Enum.zip(
        Regex.scan(@symbol_re, line, return: :binary) |> List.flatten(),
        Regex.scan(@symbol_re, line, return: :index)
        |> Enum.map(fn [{x, 1}] ->
          [
            {x + 1, y},
            {x - 1, y},
            {x, y + 1},
            {x, y - 1},
            {x + 1, y + 1},
            {x - 1, y - 1},
            {x + 1, y - 1},
            {x - 1, y + 1}
          ]
        end)
      ) ++ acc[:adjacent_coords]
    )
  end
end
