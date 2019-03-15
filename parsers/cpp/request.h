#ifndef HOBBIT_REQUEST_H
#define HOBBIT_REQUEST_H

#include <string>
#include <vector>
#include <stdexcept>
#include <algorithm>
#include "util.h"

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


        ewp_request(const std::string& in)
        {
            this->parse(in);
        }
    

        void parse(const std::string& in)
        {
            size_t index = in.find('\n');
            const auto request_line = in.substr(0,index);
            

            auto request = explode(request_line,' ');
            if(request.size() < 7){
                throw std::invalid_argument("Not enough parameters");
                //Not enough parameters
            }
            
            this->proto = request[0];
            this->version = request[1];
            this->command = request[2];
            this->compression = request[3];
            this->response_compression = explode(request[4],',');
            this->head_only_indicator = (request.size() == 8 && request[7] == "H");
            if(index != std::string::npos){
                const auto request_body = in.substr(index+1);
                this->header = request_body.substr(0,std::stoi(request[5]));
                this->body = request_body.substr(std::stoi(request[5]),std::stoi(request[6]));
            }
            
        }

        std::string marshal() const noexcept 
        {
            std::string out = this->proto + " ";
            out += this->version + " ";
            out += this->command + " ";
            out += this->compression + " ";
            for (size_t i = 0; i < this->response_compression.size(); i++){
                if(i != 0){
                    out += ",";
                }
                out += this->response_compression[i];
            }
            out += " " + std::to_string(this->header.size());
            out += " " + std::to_string(this->body.size());
            if(this->head_only_indicator){
                out += " H\n";
            }else{
                out += "\n";
                out += this->header + this->body;
            }
            return out;
        }
    };
}



#endif