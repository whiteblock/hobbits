#ifndef HOBBIT_RESPONSE_H
#define HOBBIT_RESPONSE_H
/**
 * POC DO NOT USE IN PRODUCTION 
 * UNSAFE UNSAFE UNSAFE
 */
#include <stdio.h>
#include <string.h>
#include "util.h"


struct ewp_response{
    int response_status;
    char* compression;
    char* header;
    char* body;
    int header_length;
    int body_length;
    unsigned int has_body;
};


int ewp_response_parse(char* in,struct ewp_response* res)
{
    int index = index_of_char(in,'\n');
    char* response_line = substring(in,0,index);
    
    char* response_body = (char*)(in + index);

    vector response = explode(" ",response_line);


    if(vector_length(response) < 3){
        vector_free(response);
        return 1;
        //Not enough parameters
    }

    res->response_status = atoi((char*)vector_get(response,0));

    res->compression = (char*)calloc(strlen((char*)vector_get(response,1))+1,sizeof(char));
    strcpy(res->compression,(char*)vector_get(response,1));

    res->header_length = atoi((char*)vector_get(response,2));

    res->header = substring(response_body,0,res->header_length);
    if(vector_length(response) == 4){
        res->body_length = atoi((char*)vector_get(response,3));
        res->body = substring(response_body, res->header_length, res->header_length+res->body_length);
        res->has_body = 1;
    }else{
        res->body_length = 0;
        res->has_body = 0;
    }
    vector_free(response);
    return 0;
}

char* ewp_response_marshal(struct ewp_response* res,size_t* size)
{
    char* tmp;
    char* intval;
    *size = 0;
    intval = ltoa(res->response_status);
    char* out = strappend(' ',ltoa(res->response_status));
    *size += strlen(out);   
    tmp = strappend(' ',res->compression);
    *size += strlen(tmp);
    out = concat(out,tmp, FIRST|SECOND);
    intval = ltoa(res->header_length);
    tmp = strappend(' ',intval);
    *size += strlen(tmp);
    //free(intval);
    out = concat(out,tmp,FIRST | SECOND);
    if(res->has_body){
        intval = ltoa(res->header_length);
        tmp = strappend(' ',intval);
        *size += strlen(tmp);
        //free(intval);
        out = concat(out,tmp,FIRST | SECOND);
    }
    tmp = strappend('\n',out);
    *size += 1;
    free(out);
    out = tmp;
    *size += res->header_length + res->body_length;
    out = concat(out,res->header, FIRST);
    out = concat(out,res->body, FIRST);
   
    return out;
}

   




#endif