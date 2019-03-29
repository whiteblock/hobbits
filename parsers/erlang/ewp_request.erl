-module(ewp_request).

-import(string,[str/2,sub_string/3,len/1,tokens/2]).

-export([parse/1,marshal/1]).

-record(ewp_request,{
    proto,
    version,
    envelope_kind,
    header,
    body
    }).

parse(In) -> 
    Index = str(In,"\n"),
    RequestLine = string:slice(In,0,Index-1),
    RequestBody = string:substr(In,Index+1),
    Request = string:tokens(RequestLine," "),
    if
        length(Request) < 5 ->
            exit("Not enough items");
        true ->
            ok
    end,
    Proto = lists:nth(1,Request),
    Version = lists:nth(2,Request),
    EnvelopeKind = lists:nth(3,Request),
    Header = string:slice(RequestBody,0,list_to_integer(lists:nth(4,Request))),
    if
        length(Request) == 8 ->
            Body = "";
        true ->
            Body = string:slice(RequestBody,list_to_integer(lists:nth(4,Request)),list_to_integer(lists:nth(5,Request)))
            
    end,
    #ewp_request{
        proto = Proto,
        version = Version,
        envelope_kind = EnvelopeKind,
        header = Header,
        body = Body
    }
.

%ewp_request:marshal(ewp_request:parse("EWP 0.1 PING none none 2 2 H\ntest")).
%ewp_request:marshal(ewp_request:parse("EWP 0.1 PING none none 2 2\ntest")).
marshal(State)->
   
    binary_to_list(erlang:iolist_to_binary(io_lib:format("~s ~s ~s ~p ~p\n~s~s",[
        State#ewp_request.proto,
        State#ewp_request.version,
        State#ewp_request.envelope_kind,
        string:len(State#ewp_request.header),
        string:len(State#ewp_request.body),
        State#ewp_request.header,
        State#ewp_request.body
        ])))

.