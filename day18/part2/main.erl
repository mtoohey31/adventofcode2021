%% ! -sname day18-part1 -mnesia debug verbose

-module(main).

magnitude({Left, Right}) -> (3 * magnitude(Left)) + (2 * magnitude(Right));
magnitude(Number) -> Number.

parse_number(String) ->
    {ok, Tokens, _} = erl_scan:string(lists:append(String, ".")),
    {ok, Exprs} = erl_parse:parse_exprs(Tokens),
    {value, Result, _} = erl_eval:exprs(Exprs, []),
    Result.

reduce(Number) ->
    case try_explode(Number) of
        {true, NewNumber} -> reduce(NewNumber);
        false -> case try_split(Number) of
                     {true, NewNumber} -> reduce(NewNumber);
                     false -> Number
                 end
    end.

add_left({L, R}, V) ->
    {add_left(L, V), R};
add_left(N, V) ->
    N + V.

add_right({L, R}, V) ->
    {L, add_right(R, V)};
add_right(N, V) ->
    N + V.

try_explode(Number) ->
    case try_explode(Number, 0) of
        {true, P, _, _} -> {true, P};
        false -> false
    end.

try_explode({Left, Right}, N) ->
    Number = {Left, Right},
    case Number of
        {{A, B}, C} -> case try_explode({A, B}, N + 1) of
                           {true, P, L, R} -> {true, {P, add_left(C, R)}, L, 0};
                           false -> case try_explode(C, N + 1) of
                                        {true, P, L, R} -> {true, {add_right({A, B}, L), P}, 0, R};
                                        false -> false
                                    end
                       end;
        {A, {B, C}} -> case try_explode({B, C}, N + 1) of
                           {true, P, L, R} -> {true, {add_right(A, L), P}, 0, R};
                           false -> false
                       end;
        {A, B} -> case N >= 4 of
                      true -> {true, 0, A, B};
                      false -> false
                  end
    end;
try_explode(_, _) ->
    false.

try_split({Left, Right}) ->
    case try_split(Left) of
        {true, NewLeft} -> {true, {NewLeft, Right}};
        false -> case try_split(Right) of
                     {true, NewRight} -> {true, {Left, NewRight}};
                     false -> false
                 end
    end;
try_split(Number) ->
    case Number >= 10 of
        true -> {true, {trunc(Number / 2), round(Number / 2)}};
        false -> false
    end.

tupleify([Left, Right]) ->
    {tupleify(Left), tupleify(Right)};
tupleify(Number) ->
    Number.

main(_) ->
    {ok, InputBinary} = file:read_file("../input"),
    InputStrings = string:split(unicode:characters_to_list(InputBinary), "\n", all),
    InputLists = lists:filtermap(fun(S) -> case S == "" of
                                          false -> {true, parse_number(S)};
                                          _ -> false
                                      end end, InputStrings),
    InputTuples = lists:map(fun(L) -> tupleify(L) end, InputLists),
    Max = lists:max(lists:map(fun(N) -> lists:max(lists:map(fun(M) -> magnitude(reduce({lists:nth(N, InputTuples), lists:nth(M, InputTuples)})) end, lists:seq(1, N - 1) ++ lists:seq(N + 1, length(InputTuples)))) end, lists:seq(1, length(InputTuples)))),
    io:format("~w~n", [Max]).
