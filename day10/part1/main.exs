{:ok, input} = input = File.read("../input")

defmodule Parse do
  def parse(n, s, t) do
    cond do
      n == String.length(s) ->
        0
      Enum.member?(["<", "{", "[", "("], String.at(s, n)) ->
        parse(n + 1, s, t ++ [String.at(s, n)])
      String.at(s, n) == Map.get(%{ "<" => ">", "{" => "}", "[" => "]", "(" => ")" }, List.last(t)) ->
        parse(n + 1, s, Enum.drop(t, -1))
      true ->
        Map.get(%{ ">" => 25137, "}" => 1197, "]" => 57, ")" => 3 }, String.at(s, n))
    end
  end
end

IO.puts(Enum.sum(Enum.map(String.split(input, "\n"), fn s -> Parse.parse(0, s, []) end)))
