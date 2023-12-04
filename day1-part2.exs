defmodule Calibration do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
    |> Enum.sum()
  end

  defp parse_line(line) do
    len = String.length(line)

    results =
      0..len
      |> Stream.map(fn idx -> String.slice(line, idx, len - idx) |> parse_digit() end)
      |> Stream.reject(&is_nil/1)

    Enum.at(results, 0) * 10 + Enum.at(results, -1)
  end

  defp parse_digit("one" <> _), do: 1
  defp parse_digit("two" <> _), do: 2
  defp parse_digit("three" <> _), do: 3
  defp parse_digit("four" <> _), do: 4
  defp parse_digit("five" <> _), do: 5
  defp parse_digit("six" <> _), do: 6
  defp parse_digit("seven" <> _), do: 7
  defp parse_digit("eight" <> _), do: 8
  defp parse_digit("nine" <> _), do: 9
  defp parse_digit("zero" <> _), do: 0
  defp parse_digit("1" <> _), do: 1
  defp parse_digit("2" <> _), do: 2
  defp parse_digit("3" <> _), do: 3
  defp parse_digit("4" <> _), do: 4
  defp parse_digit("5" <> _), do: 5
  defp parse_digit("6" <> _), do: 6
  defp parse_digit("7" <> _), do: 7
  defp parse_digit("8" <> _), do: 8
  defp parse_digit("9" <> _), do: 9
  defp parse_digit("0" <> _), do: 0
  defp parse_digit(_), do: nil
end
