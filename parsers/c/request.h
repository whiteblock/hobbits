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
    char* compression;
    vector response_compression;
    unsigned int  head_only_indicator : 1;
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

    tmp = (char*)vector_get(request,3);
    req->compression = (char*)calloc(strlen(tmp)+1,sizeof(char));
    strcpy(req->compression,tmp);

    req->response_compression = explode(",",(char*)vector_get(request,4));
    req->head_only_indicator = (vector_length(request) == 8 && ((char*)vector_get(request,7))[0] == 'H');
    if(index != -1){
        char* request_body = substring(in,index+1,strlen(in));
        req->header_len = atoi((char*)vector_get(request,5));
        req->body_len = atoi((char*)vector_get(request,6));
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
    char* out = req->proto;
   *size += strlen(out);
    tmp = strappend(' ',req->version);
    *size += strlen(tmp);
    out = concat(out,tmp, SECOND);
    tmp = strappend(' ',req->command);
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST | SECOND);
    tmp = strappend(' ',req->compression);
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST | SECOND);

    size_t length = vector_length(req->response_compression);
    for (size_t i = 0; i < length; i++){
        if(i != 0){
            tmp = strappend(',',(char*)vector_get(req->response_compression,i));
            *size += strlen(tmp);
            out = concat(out,tmp,FIRST | SECOND);
        }else{
            *size += strlen((char*)vector_get(req->response_compression,i));
            out = concat(out,(char*)vector_get(req->response_compression,i),FIRST);
        }
    }
    tmp = strappend(' ',req->compression);
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST | SECOND);

    tmp = strappend(' ' ,ltoa(req->header_len));
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST | SECOND);
    tmp = strappend(' ' ,ltoa(req->body_len));
    *size += strlen(tmp);
    out = concat(out,tmp,FIRST | SECOND);

    if(req->head_only_indicator == 1){
        out = concat(out," H\n",FIRST);
        *size += 3;
    }else{
        tmp = concat(req->header,req->body,0);
        *size += strlen(tmp);
        out = concat(out,strappend('\n',tmp),FIRST|SECOND);
        free(tmp);
    }
    return out;
}





#endif