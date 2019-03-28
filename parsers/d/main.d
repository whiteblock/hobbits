import std.stdio;
import std.conv;

import ewp;
void main(string[] args){
    
    if(args.length != 3){
        writeln("Not enough arguments");
        return;
    }
    int size = to!int(args[2]);

    char[] buffer = new char[](size);
    stdin.rawRead(buffer);
    string input = to!string(buffer);

    if (args[1] == "request"){
        ewp.request req = new ewp.request(input);
        write(req.marshal());
    }
}