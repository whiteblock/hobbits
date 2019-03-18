-module(ewp_response).

-import(string,[str/2,sub_string/3,len/1,tokens/2]).

-export([parse/1,marshal/1]).

-record(ewp_response,{
    response_status,
    compression,
    header,
    body,
    has_body = false
    }).

%ewp_response:parse("200 none 9 10\n987654321\n\n\n\n\n\n\n\n\n\n").
parse(In) ->
    Index = str(In,"\n"),
    ResponseLine = string:slice(In,0,Index-1),
    ResponseBody = string:substr(In,Index+1),
    Response = string:tokens(ResponseLine," "),
    if
        length(Response) < 3 ->
            exit("Not enough items");
        true ->
            ok
    end,

    ResponseStatus = list_to_integer(lists:nth(1,Response)),
    Compression = lists:nth(2,Response),
    Header = string:slice(ResponseBody,0,list_to_integer(lists:nth(3,Response))),
    
    %1HasBody = false,
     
    if
        length(Response) == 4 ->
            Body = string:slice(ResponseBody,list_to_integer(lists:nth(3,Response)),list_to_integer(lists:nth(4,Response)));
        true ->
            Body = ""
    end,

    #ewp_response{
        response_status=ResponseStatus,
        compression=Compression,
        header=Header,
        body=Body,
        has_body=(length(Response) == 4)
    }
.

%ewp_response:marshal(ewp_response:parse("200 none 9 10\n987654321\n\n\n\n\n\n\n\n\n\n")).
marshal(State) ->
    if 
        State#ewp_response.has_body ->
            binary_to_list(erlang:iolist_to_binary(io_lib:format("~p ~s ~p ~p\n~s~s",[
                State#ewp_response.response_status,
                State#ewp_response.compression,
                string:len(State#ewp_response.header),
                string:len(State#ewp_response.body),
                State#ewp_response.header,
                State#ewp_response.body])));
        true ->
            binary_to_list(erlang:iolist_to_binary(io_lib:format("~p ~s ~p\n~s",[
                State#ewp_response.response_status,
                State#ewp_response.compression,
                string:len(State#ewp_response.header),
                State#ewp_response.header])))
    end
.