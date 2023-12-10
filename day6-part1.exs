defmodule Race do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.zip()
    |> Enum.map(&eval/1)
    |> Enum.product()
  end

  defp parse_line(line) do
    [_, values] = line |> String.split(": ", trim: true)
    values |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  defp eval({time, distance}) do
    held = (time - :math.sqrt(time ** 2 - 4 * distance)) / 2
    (time - 1) - floor(held) * 2
  end
end

