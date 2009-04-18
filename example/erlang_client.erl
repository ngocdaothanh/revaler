-module(erlang_client).

-export([start/2, send_command/1]).
-export([connect/2]).

-define(NUM_BYTES_FOR_PAYLOAD_LENGTH, 4).

start(Host, Port) ->
	Pid = spawn(?MODULE, connect, [Host, Port]),
	register(?MODULE, Pid).

send_command(Command) ->
	?MODULE ! {command, Command}.

connect(Host, Port) ->
	{ok, Socket} = gen_tcp:connect(Host, Port, [binary, {packet, ?NUM_BYTES_FOR_PAYLOAD_LENGTH}]),
	loop(Socket).

loop(Socket) ->
	receive
		{command, Command} ->
			gen_tcp:send(Socket, Command),
			loop(Socket);

		{tcp, Socket, Binary} ->
			io:format("~p~n", [Binary]),
			loop(Socket);

		_ ->
			ok
	end.
