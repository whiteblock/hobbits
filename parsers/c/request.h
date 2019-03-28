#ifndef HOBBIT_REQUEST_H
#define HOBBIT_REQUEST_H
/**
 * POC DO NOT USE IN PRODUCTION 
 * UNSAFE UNSAFE UNSAFE
 */
#include <stdio.h>
#include <string.h>
#include "util.h"

struct ewp_request {
    char* proto;
    char* version;
    char* command;
    size_t header_len;
    size_t body_len;
    char* header;
    char* body;
};

int ewp_request_parse(char* in,struct ewp_request* req)
{
    int index = index_of_char(in,'\n');
    char* request_line = substring(in,0,index);

    vector request = explode(" ",request_line);
    //printf("%d\n",vector_length(request));
    if(vector_length(request) < 7){
        vector_free(request);
        return 1;
        //Not enough parameters
    }
    
    char* tmp = (char*)vector_get(request,0);
    req->proto = (char*)calloc(strlen(tmp)+1,sizeof(char));
    strcpy(req->proto,tmp);

    tmp = (char*)vector_get(request,1);
    req->version = (char*)calloc(strlen(tmp)+1,sizeof(char));
    strcpy(req->version,tmp);

    tmp = (char*)vector_get(request,2);
    req->command = (char*)calloc(strlen(tmp)+1,sizeof(char));
    strcpy(req->command,tmp);

    if(index != -1){
        char* request_body = substring(in,index+1,strlen(in));
        req->header_len = atoi((char*)vector_get(request,3));
        req->body_len = atoi((char*)vector_get(request,4));
        req->header = substring(request_body,0,req->header_len);
        req->body = substring(request_body,req->header_len,req->body_len);
        free(request_body);
    }
    vector_free(request);
    return 0;
    
}

char* ewp_request_marshal(struct ewp_request* req,size_t* size)
{   

    char* tmp;
    char* out =strappend(' ', req->proto);
    *size += strlen(out);
    tmp = strappend(' ',req->version);
    *size += strlen(tmp);
    out = concat(out,tmp, SECOND);
    tmp = strappend(' ',req->command);
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST | SECOND);

    tmp = strappend(' ' ,ltoa(req->header_len));
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST | SECOND);

    tmp = ltoa(req->body_len);
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST);

    tmp = strappend('\n',out);
    free(out);
    out = tmp;
    *size += 1;

    tmp = memsafe_concat(req->header,req->header_len,req->body,req->body_len,0);
       
    out = memsafe_concat(out,*size,tmp,req->header_len + req->body_len,FIRST|SECOND);
    *size += req->header_len + req->body_len;
        
    return out;
}





#endif