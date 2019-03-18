#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
#include <istream>
#include "request.h"
#include "response.h"

using namespace std;

string parse_input(size_t size){
    const size_t buffer_size = 100;
    size_t len = 0;
    string out;
    char buffer[buffer_size];

    while(len < size){
        size_t max_to_read = std::min(buffer_size - 1,size - len);

        cin.read(buffer,max_to_read);
        out.append(buffer,max_to_read);
        len += max_to_read;
    }
    return out;
}

int main(int argc,char** argv)
{
    
    if(argc == 1){
        hobbit::ewp_request req(string("EWP 0.1 PING none none 0 5\n12345"));
        hobbit::ewp_response res(string("200 none 5 5\n1234512345"));

        cout<<req.marshal()<<endl<<endl;
        cout<<res.marshal()<<endl<<endl;
        return EXIT_SUCCESS;
    }

    if(argc == 2) {
        cout<<"Missing a size argument"<<endl;
        return EXIT_FAILURE;
    }
    size_t size = atol(argv[2]);
    string type(argv[1]);
    string input = parse_input(size);
    if(type == "request"){
        hobbit::ewp_request req(input);
        cout<<req.marshal();
    }else if(type == "response"){
        hobbit::ewp_response res(input);
        cout<<res.marshal();
    }else{
        cout<<"Unknown option"<<endl;
    }

    return EXIT_SUCCESS;
}

