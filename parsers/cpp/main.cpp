#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
#include "hobbit.h"

using namespace std;

int main(int argc,char** argv)
{   
    auto res =  hobbit::parse(string("EWP 0.1 PING none none 0 5\n12345"));
    cout<<res.proto<<endl;
    cout<<res.version<<endl;
    cout<<res.command<<endl;
    cout<<res.compression<<endl;
    std::for_each(res.response_compression.begin(),res.response_compression.end(),[](const string& part){
        cout<<part<<",";
    });
    cout<<endl;
    cout<<res.head_only_indicator<<endl;
    cout<<res.header<<endl;
    cout<<res.body<<endl;
}