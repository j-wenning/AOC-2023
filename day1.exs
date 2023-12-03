defmodule Calibration do
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Stream.filter(&(&1 != ""))
    |> Stream.map(&parse_line/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  @numeric_re ~r/\d|one|two|three|four|five|six|seven|eight|nine|zero/
  defp parse_line(input) do
    %{:first => first, :last => last} = branching_scan(%{}, @numeric_re, input)
    parse_digit(first) * 10 + parse_digit(last)
  end

  defp parse_literal(int_str) do
    {i, _} = Integer.parse(int_str)
    i
  end

  defp parse_digit(str) do
    case str do
      "one" -> 1
      "two" -> 2
      "three" -> 3
      "four" -> 4
      "five" -> 5
      "six" -> 6
      "seven" -> 7
      "eight" -> 8
      "nine" -> 9
      "zero" -> 0
      _ -> parse_literal(str)
    end
  end

  defp branching_scan(acc, _regex, "") do
    acc
  end

  defp branching_scan(acc, regex, target) do
    result = Regex.run(regex, target, return: :index, capture: :first)

    if result == nil do
      acc
    else
      {idxStart, idxEnd} = List.first(result)
      {_, tail} = String.split_at(target, idxStart + 1)
      str = String.slice(target, idxStart, idxEnd)
      acc |> Map.put_new(:first, str) |> Map.put(:last, str) |> branching_scan(regex, tail)
    end
  end
end
