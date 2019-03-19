#ifndef HOBBIT_UTIL_H
#define HOBBIT_UTIL_H

#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <stdarg.h>
#include "vector.h"

#define TRUE 1
#define FALSE 0
#define FIRST 1
#define SECOND 2

char* strappend(char s,const char* str){
    size_t length = strlen(str);
    char* out = (char*)malloc(sizeof(char)*(length+2));
    if(str!=NULL){
        strcpy(out,str);
    }
    out[length + 1] = '\0';
    out[length] = s;
    return out;
}

unsigned int strcompsub(char* str1,char* str2, size_t index, size_t length)
{
    int_fast64_t i;
    if(length != strlen(str1)){
        return FALSE;
    }
    for(i = index;i<length+index;i++){
        if(str1[i-index] != str2[i]){
            return FALSE;
        }
    }
    return TRUE;
}

char* substring(char* subject,size_t index,int length)
{
    if(length < 0){
        return substring(subject,index,(strlen(subject) - (index - length)));
    }
    char* out = (char*)calloc(length + 1,sizeof(char));
    uint_fast64_t i;

    for(i = 0;i<length;i++){
        out[i] = subject[i+index];
    }
    out[length] = '\0';
    return out;
}


char* substr(char* subject,int index)
{
    uint64_t length = strlen(subject);
    char* out;
    uint_fast64_t i = 0;
    if(length < index+1){
        return NULL;
    }
    out = (char *)calloc((length-index + 1),sizeof(char));
    while(subject[i+index] != '\0'){
        out[i] = subject[i+index];
        i++;
    }
    out[i] = '\0';
    return out;
}

char* substr_f(char* subject,size_t index)
{
    char* out = substr(subject,index);
    free(subject);
    return out;
}

int index_of_char(char* haystack, char needle)
{
    size_t length = strlen(haystack);
    uint_fast64_t i;
    for(i = 0;i<length;i++){
        if(haystack[i]==needle){
            return i;
        }
    }
    return -1;
}

char* concat(char* s1, char* s2, uint8_t mem){
    uint_fast64_t l1 = strlen(s1);
    uint_fast64_t l2 = strlen(s2);
    size_t length = l1 + l2;
    char* out = (char*)calloc(length+1,sizeof(char));
    uint_fast64_t i;
    for(i = 0;i<l1;i++){
        out[i] = s1[i];
    }
    for(i = 0;i<l2;i++){
        out[i+l1] = s2[i];
    }
    if((mem >> 1)& 1){
        free(s2);
    }
    if((mem & 1)){
        free(s1);
    }
    out[length] = '\0';
    return out;
}

char* memsafe_concat(char* s1,size_t l1, char* s2,size_t l2, uint8_t mem){
    size_t length = l1 + l2;
    char* out = (char*)calloc(length+1,sizeof(char));
    uint_fast64_t i;
    for(i = 0;i<l1;i++){
        out[i] = s1[i];
    }
    for(i = 0;i<l2;i++){
        out[i+l1] = s2[i];
    }
    if((mem >> 1)& 1){
        free(s2);
    }
    if((mem & 1)){
        free(s1);
    }
    out[length] = '\0';
    return out;
}

char* ltoa(uint64_t num){
    char * characters[10] = {"0","1","2","3","4","5","6","7","8","9"};
    return (num>=10)? concat(ltoa(num/10),characters[num%10],FALSE) : characters[num];
}


char* concat_all(int args,...){
    va_list valist;
    int i = 0;
    char* output;
    va_start(valist, args);
    for(i = 0;i<args;i++){
        if(i == 0){
            output = concat(output,(char*)va_arg(valist, char*),FALSE);
        }else{
            output = concat(output,(char*)va_arg(valist, char*),FIRST);
        }
    }
    va_end(valist);
    return output;
}

vector explode(char* quan,char* subject)
{
    vector out = NULL;
    char * subj;
    uint_fast64_t i;                                             
    size_t qlength = strlen(quan);
    size_t slength = strlen(subject);
    subj = (char*)calloc(slength+1,sizeof(char));
    strcpy(subj,subject);
    subj[slength] = '\0';
    for(i = 0;i<slength-qlength;i++){
        if(strcompsub(quan,subj,i,qlength)){
            vector_push(&out,substring(subj,0,i));
            subj = substr_f(subj,i+1);
            i = 0;
            slength = strlen(subj);
        }
    }
    if(slength > 0 ){
        vector_push(&out,subj);
    }

    return out;
}

vector split(char quan,char* subject){
    vector out = NULL;
    int index = index_of_char(subject,quan);
    vector_push(&out,substring(subject,0,index));
    vector_push(&out,substr(subject,index+1));
    return out;
}

#endif