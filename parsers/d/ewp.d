import std.stdio;
import std.string;
import std.array;
import std.conv;

//module ewp;

class response{
public:
    int _response_status;
    string _compression;
    string _header;
    string _body;
    bool _has_body;
    this(string input)
    {
        this.parse(input);
    }

    void parse(string input)
    {
        ptrdiff_t index = indexOf(input,'\n');

        string response_line = input[0 .. index];
        string response_body = input[index+1 .. $];
        auto request = split(response_line,' ');
        if(request.length < 3){
            writeln("Invalid response"); 
            return;
        }
        _response_status = to!int(request[0]);
        _compression = request[1];
        _header = response_body[0 .. to!int(request[2])];
        if(request.length == 4){
            _body = response_body[to!int(request[2]) .. to!int(request[2]) + to!int(request[3])];
            _has_body = true;
        }else{
            _has_body = false;
        }

    }

    string marshal()
    {
        string ret = to!string(_response_status,10) ~ " " ~ _compression ~ " " ~ to!string(_header.length,10);
        if(_has_body){
            ret = ret ~ " " ~ to!string(_body.length);
        }
        ret = ret ~ "\n" ~ _header ~ _body;
        return ret;
    }
}

class request{
    string _proto;
    string _version;
    string _command;
    string _compression;
    string[] _response_compression;
    bool _head_only_indicator;
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
        if(request.length < 7){
            writeln("Not enough parameters");
        }
        _proto = request[0];
        _version = request[1];
        _command = request[2];
        _compression = request[3];
        _response_compression = split(request[4],',');
        _head_only_indicator = (request.length == 8 && request[7] == "H");
        if(index != -1){
            string request_body = input[index+1 .. $];
            _header = request_body[0 .. to!int(request[5])];
            _body = request_body[to!int(request[5]) .. to!int(request[5]) + to!int(request[6])];
        }
    }

    string marshal()
    {
        string ret = _proto ~ " " ~ _version ~ " ";
        ret = ret ~ _command ~ " " ~ _compression ~ " ";

        for(int i = 0; i < _response_compression.length; i++){
            if(i != 0){
                ret = ret ~ ",";
            }
            ret = ret ~ _response_compression[i];
        }
        ret = ret ~ " " ~ to!string(_header.length) ~ " " ~ to!string(_body.length);
        if(_head_only_indicator){
            ret = ret ~ " H\n";
        }else{
            ret = ret ~ "\n" ~ _header ~ _body;
        }
        return ret;
    }
}

