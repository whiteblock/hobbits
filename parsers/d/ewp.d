import std.stdio;
import std.string;
import std.array;
import std.conv;

//module ewp;

class request{
    string _proto;
    string _version;
    string _command;
    string _header;
    string _body;
    this(string input)
    {
        this.parse(input);
    }

    void parse(string input)
    {
        ptrdiff_t index = indexOf(input,'\n');
        string request_line = input[0 .. index];

        auto request = split(request_line,' ');
        if(request.length < 5){
            writeln("Not enough parameters");
        }
        _proto = request[0];
        _version = request[1];
        _command = request[2];
        if(index != -1){
            string request_body = input[index+1 .. $];
            _header = request_body[0 .. to!int(request[3])];
            _body = request_body[to!int(request[3]) .. to!int(request[3]) + to!int(request[4])];
        }
    }

    string marshal()
    {
        string ret = _proto ~ " " ~ _version ~ " ";
        ret = ret ~ _command;

        ret = ret ~ " " ~ to!string(_header.length) ~ " " ~ to!string(_body.length);
        ret = ret ~ "\n" ~ _header ~ _body;
        return ret;
    }
}

