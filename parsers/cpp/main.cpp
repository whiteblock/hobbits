#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
#include "request.h"
#include "response.h"

using namespace std;

int main(int argc,char** argv)
{   
    hobbit::ewp_request req(string("EWP 0.1 PING none none 0 5\n12345"));
    hobbit::ewp_response res(string("200 none 5 5\n1234512345"));

    cout<<req.marshal()<<endl<<endl;
    cout<<res.marshal()<<endl<<endl;
    return 0;
}