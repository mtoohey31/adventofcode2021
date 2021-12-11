{:ok, input} = input = File.read("../input")

defmodule Parse do
  def parse(n, s, t) do
    cond do
      n == String.length(s) ->
        score(t, 0)
      Enum.member?(["<", "{", "[", "("], String.at(s, n)) ->
        parse(n + 1, s, t ++ [String.at(s, n)])
      String.at(s, n) == Map.get(%{ "<" => ">", "{" => "}", "[" => "]", "(" => ")" }, List.last(t)) ->
        parse(n + 1, s, Enum.drop(t, -1))
      true ->
        0
    end
  end

  def score(t, s) do
    if length(t) == 0 do
      s
    else
      score(Enum.drop(t, -1), (s * 5) + Map.get(%{ "(" => 1, "[" => 2, "{" => 3, "<" => 4 }, List.last(t)))
    end
  end
end

scores = Enum.sort(Enum.filter(Enum.map(String.split(input, "\n"), fn s -> Parse.parse(0, s, []) end), fn x -> x != 0 end))
IO.puts(Enum.at(scores, Integer.floor_div(length(scores), 2)))
