defmodule Calibration do
  def parse_input(input) do
    String.split(input, "\n")
    |> Stream.filter(&(&1 != ""))
    |> Stream.map(&parse_line/1)
    |> Stream.map(&parse_maybe_int/1)
    |> Enum.reduce(&Kernel.+/2)
  end

  defp parse_maybe_int(maybe_int) do
    case Integer.parse(maybe_int) do
      {i, _} -> i
      :error -> 0
    end
  end

  defp parse_line(input) do
    %{:first => first, :last => last} =
      String.graphemes(input)
      |> Enum.reduce(%{}, fn x, acc ->
        if Regex.match?(~r/\d/, x),
          do: Map.put_new(acc, :first, x) |> Map.put(:last, x),
          else: acc
      end)

    first <> last
  end
end
