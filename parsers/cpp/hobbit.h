#ifndef HOBBIT_H
#define HOBBIT_H

#include <string>
#include <vector>

namespace hobbit{

    struct ewp_request {
        std::string proto;
        std::string version;
        std::string command;
        std::string compression;
        std::vector<std::string> response_compression;
        bool head_only_indicator;
        std::string header;
        std::string body;
    };

    template<class T>
    std::vector<T> explode(const T& subj,char quan)
    {
        std::vector<T> out;
        size_t slength = subj.size();
        size_t index = 0;

        for(size_t i = 0;i < slength - 1;i++){
            if(quan == subj.at(i+index)){
                if(i != 0){
                    out.emplace_back(subj.substr(index,i));
                }
                
                index += i+1;
                slength -= i+1;
                i = 0;
            }
        }
        if(index < subj.size()){
            out.emplace_back(subj.substr(index));
        }

        return out;
    }

    ewp_request parse(const std::string& in)
    {
        auto req_split = explode(in,'\n');
        if(req_split.size() < 2){
            //Missing body
        }
        auto request = explode(req_split[0],' ');
        if(request.size() < 7){

            //Not enough parameters
        }
        ewp_request out;
        out.proto = request[0];
        out.version = request[1];
        out.command = request[2];
        out.compression = request[3];
        out.response_compression = explode(request[4],',');
        out.head_only_indicator = (request.size() == 8 && request[7] == "H");
        out.header = req_split[1].substr(0,std::stoi(request[5]));
        out.body = req_split[1].substr(std::stoi(request[5]),std::stoi(request[6]));
        return out;
    }
}



#endif