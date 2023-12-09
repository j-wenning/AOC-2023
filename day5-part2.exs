defmodule Almanac do
  def parse_input(input) do
    [seeds | mappings] = input |> String.split("\n\n", trim: true)
    seeds = parse_seeds(seeds)
    mappings = parse_maps(mappings)

    resolve_locations(seeds, mappings)
    |> Stream.map(& &1.first)
    |> Enum.min()
  end

  defmodule Range do
    @enforce_keys [:first, :last]
    defstruct [:first, :last]
  end

  defmodule Mapping do
    @enforce_keys [:source, :destination, :values]
    defstruct [:source, :destination, :values]
  end

  defp parse_seeds(input) do
    [_ | seeds] = input |> String.split(" ", trim: true)

    seeds
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2)
    |> Enum.map(fn [first, len] -> %Range{first: first, last: first + len} end)
  end

  defp parse_maps(input) do
    input
    |> Stream.map(fn input ->
      [locations | values] = input |> String.split("\n", trim: true)

      [source, destination] =
        locations
        |> String.split(" ", trim: true)
        |> hd()
        |> String.split("-to-")
        |> Enum.map(&String.to_atom/1)

      values =
        values
        |> Enum.map(fn value ->
          [destination, source, len] =
            value
            |> String.split(" ", trim: true)
            |> Enum.map(&String.to_integer/1)

          {
            %Range{first: destination, last: destination + len},
            %Range{first: source, last: source + len}
          }
        end)

      %Mapping{source: source, destination: destination, values: values}
    end)
    |> Enum.reduce(%{}, fn map, acc ->
      acc |> Map.put(map.source, map)
    end)
  end

  defp resolve_locations(sources, mappings, current_mapping \\ :seed)

  defp resolve_locations(sources, _mappings, :location), do: sources

  defp resolve_locations(sources, mappings, current_mapping) do
    %Mapping{destination: next_mapping, values: mapping_values} =
      mappings |> Map.get(current_mapping)

    sources
    |> Stream.map(&translate_mappings([&1], mapping_values))
    |> Stream.flat_map(&resolve_locations(&1, mappings, next_mapping))
  end

  defp translate_mappings(sources, []), do: sources

  defp translate_mappings(sources, [{%Range{} = m_destination, %Range{} = m_source} | rest]) do
    sources
    |> Enum.flat_map(fn source ->
      %{overlap: overlap, excluded: excluded} = range_overlap(source, m_source)

      diff = m_source.first - m_destination.first

      overlap =
        Enum.map(overlap, fn range ->
          %Range{first: range.first - diff, last: range.last - diff}
        end)

      excluded = translate_mappings(excluded, rest)

      overlap ++ excluded
    end)
  end

  defp range_overlap(%Range{} = a, %Range{} = b) do
    cond do
      a.last < b.first or a.first > b.last ->
        %{
          overlap: [],
          excluded: [a]
        }

      a.first >= b.first and a.last <= b.last ->
        %{
          overlap: [a],
          excluded: []
        }

      a.first < b.first and a.last > b.last ->
        %{
          overlap: [b],
          excluded: [%Range{first: a.first, last: b.first}, %Range{first: b.last, last: a.last}]
        }

      a.first < b.first and a.last <= b.last ->
        %{
          overlap: [%Range{first: b.first, last: a.last}],
          excluded: [%Range{first: a.first, last: b.first}]
        }

      a.first >= b.first and a.last > b.last ->
        %{
          overlap: [%Range{first: a.first, last: b.last}],
          excluded: [%Range{first: b.last, last: a.last}]
        }
    end
  end
end
