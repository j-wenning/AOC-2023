defmodule Race do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.zip()
    |> hd()
    |> eval()
  end

  defp parse_line(line) do
    [_, values] = line |> String.split(": ", trim: true)
    [values |> String.replace(" ", "") |> String.to_integer()]
  end

  defp eval({time, distance}) do
    held = (time - :math.sqrt(time ** 2 - 4 * distance)) / 2
    (time - 1) - floor(held) * 2
  end
end

