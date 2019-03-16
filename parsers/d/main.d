import std.stdio;
import std.conv;

import ewp;
void main(string[] args){
    /*ewp.response res =  new ewp.response("200 none 5\nhello");
    writeln(res.marshal());
    ewp.request req = new ewp.request("EWP 0.1 PING none none 0 0 H\n");
    writeln(req.marshal());*/
    
    if(args.length != 3){
        writeln("Not enough arguments");
        return;
    }
    int size = to!int(args[2]);

    char[] buffer = new char[](size);
    stdin.rawRead(buffer);
    string input = to!string(buffer);

    if(args[1] == "response"){
        ewp.response res =  new ewp.response(input);
        write(res.marshal());
    }else if (args[1] == "request"){
        ewp.request req = new ewp.request(input);
        write(req.marshal());
    }
}