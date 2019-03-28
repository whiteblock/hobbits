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
            if(index != std::string::npos){
                const auto request_body = in.substr(index+1);
                this->header = request_body.substr(0,std::stoi(request[3]));
                this->body = request_body.substr(std::stoi(request[3]),std::stoi(request[4]));
            }
            
        }

        std::string marshal() const noexcept 
        {
            std::string out = this->proto + " ";
            out += this->version + " ";
            out += this->command + " ";
            out += " " + std::to_string(this->header.size());
            out += " " + std::to_string(this->body.size());
            return out;
        }
    };
}



#endif