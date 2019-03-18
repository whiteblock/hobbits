-module(ewp_request).

-import(string,[str/2,sub_string/3,len/1,tokens/2]).

-export([parse/1,marshal/1]).

-record(ewp_request,{
    proto,
    version,
    command,
    compression,
    response_compression,
    has_body = false,
    header,
    body
    }).
%ewp_request:parse("EWP 0.1 PING none none 2 2 H\ntest").
parse_compression(RespCompStr) ->
    parse_compression(RespCompStr,[]).

parse_compression(RespCompStr,Prog) ->

    Index = string:str(RespCompStr,","),
    if 
        Index < 1 ->
            [RespCompStr];
        true ->

        parse_compression(string:substr(RespCompStr,Index+1),[Prog|string:slice(RespCompStr,0,Index)])
    end

.

parse(In) -> 
    Index = str(In,"\n"),
    RequestLine = string:slice(In,0,Index-1),
    RequestBody = string:substr(In,Index+1),
    Request = string:tokens(RequestLine," "),
    if
        length(Request) < 7 ->
            exit("Not enough items");
        true ->
            ok
    end,
    Proto = lists:nth(1,Request),
    Version = lists:nth(2,Request),
    Command = lists:nth(3,Request),
    Compression = lists:nth(4,Request),
    ResponseCompression = parse_compression(lists:nth(5,Request)),
    HasBody = length(Request) == 7,
    Header = string:slice(RequestBody,0,list_to_integer(lists:nth(6,Request))),
    if
        length(Request) == 8 ->
            Body = "";
        true ->
            Body = string:slice(RequestBody,list_to_integer(lists:nth(6,Request)),list_to_integer(lists:nth(7,Request)))
            
    end,
    #ewp_request{
        proto = Proto,
        version = Version,
        command = Command,
        compression = Compression,
        response_compression = ResponseCompression,
        has_body = HasBody,
        header = Header,
        body = Body
    }
.

%ewp_request:marshal(ewp_request:parse("EWP 0.1 PING none none 2 2 H\ntest")).
%ewp_request:marshal(ewp_request:parse("EWP 0.1 PING none none 2 2\ntest")).
marshal(State)->
    if 
        State#ewp_request.has_body ->
            binary_to_list(erlang:iolist_to_binary(io_lib:format("~s ~s ~s ~s ~s ~p ~p\n~s~s",[
                State#ewp_request.proto,
                State#ewp_request.version,
                State#ewp_request.command,
                State#ewp_request.compression,
                lists:join(",",State#ewp_request.response_compression),
                string:len(State#ewp_request.header),
                string:len(State#ewp_request.body),
                State#ewp_request.header,
                State#ewp_request.body
                ])));
        true ->
            binary_to_list(erlang:iolist_to_binary(io_lib:format("~s ~s ~s ~s ~s ~p ~p H\n~s~s",[
                State#ewp_request.proto,
                State#ewp_request.version,
                State#ewp_request.command,
                State#ewp_request.compression,
                lists:join(",",State#ewp_request.response_compression),
                string:len(State#ewp_request.header),
                string:len(State#ewp_request.body),
                State#ewp_request.header,
                State#ewp_request.body
                ])))
    end
.