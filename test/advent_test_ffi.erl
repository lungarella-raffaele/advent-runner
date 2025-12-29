-module(advent_test_ffi).
-export([new_collector/0, append/2, get_all/1]).

%% Creates a new ETS table to collect strings.
%% Returns the table reference.
new_collector() ->
    ets:new(output_collector, [ordered_set, public]).

%% Appends a string to the collector.
%% Uses the table size as key to maintain insertion order.
append(Table, Value) ->
    Key = ets:info(Table, size),
    ets:insert(Table, {Key, Value}),
    nil.

%% Gets all collected strings in insertion order.
get_all(Table) ->
    Items = ets:tab2list(Table),
    Sorted = lists:keysort(1, Items),
    [V || {_K, V} <- Sorted].
