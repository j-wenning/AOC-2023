defmodule Schematic do
  def parse_input(input) do
    %{:part_nums => part_nums, :adjacent_coords => adjacent_coords} =
      input
      |> String.split("\n", trim: true)
      |> Stream.with_index()
      |> Enum.reduce(%{:part_nums => [], :adjacent_coords => []}, &parse_line/2)

    part_nums =
      part_nums
      |> Enum.reduce(%{}, fn {num, coords}, acc ->
        # allow for deduping values based on the head of the group
        {x, y} = hd(coords)
        coords |> Enum.reduce(acc, &Map.put(&2, &1, {num, x, y}))
      end)

    adjacent_coords
    |> Stream.filter(fn {sym, _} -> sym == "*" end)
    |> Stream.map(fn {_, coords} ->
      coords
      |> Stream.map(fn coord -> part_nums[coord] end)
      |> Stream.reject(&Kernel.is_nil/1)
      |> Enum.sort()
      |> Stream.dedup()
      |> Enum.map(fn {num, _x, _y} -> String.to_integer(num) end)
    end)
    |> Stream.filter(fn nums -> length(nums) == 2 end)
    |> Stream.map(&Enum.product/1)
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
