
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include "request.h"
#include "response.h"


int main(int argc,char** argv)
{   
    if(argc != 3){
        perror("Invalid number of arguments\n");
        return EXIT_FAILURE;
    }
    int size = atoi(argv[2]);
    char* buffer = (char*)calloc(size+1,sizeof(char));
    size_t output_size = 0;
    if(read(0,buffer,size) == -1){
        perror("recv had an error");
        return EXIT_FAILURE;
    }

    if(strcmp(argv[1],"response") == 0 ){
        struct ewp_response* resp = (struct ewp_response*)malloc(sizeof(struct ewp_response));
        if(ewp_response_parse(buffer,resp) != 0){
            write(2,"Parse failed\n",13);
            return EXIT_FAILURE;
        }
        char* out = ewp_response_marshal(resp,&output_size);
        write(1,out,output_size);
    }else if (strcmp(argv[1],"request") == 0){
        struct ewp_request* req = (struct ewp_request*)malloc(sizeof(struct ewp_request));
        if(ewp_request_parse(buffer,req) != 0){
            write(2,"Parse failed\n",13);
            return EXIT_FAILURE;
        }
        char* out = ewp_request_marshal(req,&output_size);
        write(1,out,output_size);
    }else{
        perror("Invalid first argument\n");
        return EXIT_FAILURE;
    }

    
    return EXIT_SUCCESS;
}