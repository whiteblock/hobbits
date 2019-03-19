#ifndef vector_H
#define vector_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct vect* vector;
struct vect{
    vector next;
    vector prev;
    void* data;
};

static vector create_vector(){
    vector out = (vector) malloc(sizeof(struct vect));
    out->next = NULL;
    out->prev = NULL;
    out->data = NULL;
    return out;
}

size_t vector_length(vector v){
    size_t length = 0;
    vector tmp = v;
    if(v==NULL){
        return 0;
    }
    while(tmp != NULL){
        tmp = tmp->next;
        length++;
    }
    return length;
}

void* vector_get(vector v,size_t index){
    vector tmp = v;
    int i = 0;
    while(i !=  index && tmp != NULL){
        tmp = tmp->next;
        i++;
    }
    return tmp->data;
}

void vector_clean(vector v){
    vector tmp = v;
    vector clear = NULL;
    if(v==NULL){
        return;
    }
    
    while(tmp != NULL){
        
        clear = tmp;
        tmp = tmp->next;
        clear->next = NULL;
        clear->prev = NULL;
        if(clear->data)
            free(clear->data);
        free(clear);
    }
}

void* vector_get_f(vector v,size_t index){
    char * out = vector_get(v,index);
    vector_clean(v);
    return out;
}

void vector_pop(vector* v, size_t index){
    if(v==NULL || *v == NULL){
        return;
    }
    vector tmp = *v;
    vector p;
    int i = 0;
    if(index == 0){
        *v = tmp->next;
        free(tmp);
        if(*v != NULL){
            (*v)->prev = NULL;
        }
        return;
    }
    while(i !=  index && tmp != NULL){
        tmp = tmp->next;
        i++;
    }
    p = tmp->prev;
    p->next = tmp->next;
    tmp->next->prev = p;
    free(tmp);
}



void vector_push(vector * v,void* data){
    vector add = create_vector();
    vector tmp;
    add->data = data;
    if(v==NULL||*v==NULL){
        *v = add;
        return;
    }

    tmp = *v;
    while(tmp->next != NULL){
        tmp = tmp->next;
    }
    tmp->next = add;
    add->prev = tmp;
}



void vector_free(vector v){
    vector tmp = v;
    vector clear = NULL;
    if(v==NULL){
        return;
    }
    
    while(tmp->next != NULL){
        tmp = tmp->next;
        clear = tmp->prev;
        clear->next = NULL;
        clear->prev = NULL;
        clear->data = NULL;
        free(clear);
    }
    free(tmp);
}

vector vector_merge(vector * v1, vector * v2){
    int i;
    for(i = 0;i<vector_length(*v2);i++){
        vector_push(v1,vector_get(*v2,i));
    }
    if(*v2!=NULL){
        free(*v2);
    }
    return *v1;
}

void vector_print_i(vector v1){
    vector v = v1;
    puts("Printing vector contents as ints");
    while(v!=NULL){
        printf("%d\n",*((int *)v->data));
        v = v->next;
    }
    puts("done");
}

void ** vector_to_array(vector v){
    size_t size = vector_length(v);
    void ** out = (void**)calloc(sizeof(void*),size+1);
    out[size] = NULL;
    int32_t i = 0;
    for(i = 0;i<size;i++){
        void* value = vector_get(v,i);
        out[i] = value;
    }
    return out;
}

#endif