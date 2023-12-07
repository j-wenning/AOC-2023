defmodule Almanac do
  def parse_input(input) do
    [seeds | maps] = input |> String.split("\n\n", trim: true)
    seeds = parse_seeds(seeds)
    maps = parse_maps(maps)

    seeds
    |> Stream.map(&get_seed_location(&1, maps))
    |> Enum.min()
  end

  defp parse_seeds(input) do
    [_ | seeds] = input |> String.split(" ", trim: true)
    seeds |> Enum.map(&String.to_integer/1)
  end

  defp parse_maps(input) do
    input
    |> Stream.map(fn input ->
      [locations | values] = input |> String.split("\n", trim: true)

      [from, to] =
        locations
        |> String.split(" ", trim: true)
        |> hd()
        |> String.split("-to-")
        |> Enum.map(&String.to_atom/1)

      values =
        values
        |> Enum.map(fn value ->
          [to, from, range] =
            value
            |> String.split(" ", trim: true)
            |> Enum.map(&String.to_integer/1)

          {to, from, range}
        end)

      {to, from, values}
    end)
    |> Enum.reduce(%{}, fn map, acc ->
      acc |> Map.put(map |> elem(1), map)
    end)
  end

  defp get_seed_location(id, maps, current \\ :seed)

  defp get_seed_location(id, _maps, :location) do
    id
  end

  defp get_seed_location(id, maps, current) do
    {to, _from, values} = maps |> Map.get(current)

    mapped_id =
      values
      |> Enum.find_value(fn {to, from, range} ->
        if id >= from && id <= from + range,
          do: to + (id - from)
      end)

    (mapped_id || id)
    |> get_seed_location(maps, to)
  end
end
