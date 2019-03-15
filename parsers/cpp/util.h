#ifndef HOBBIT_UTIL_H
#define HOBBIT_UTIL_H

#include <vector>

namespace hobbit{
    template<class T>
    std::vector<T> explode(const T& subj,char quan)
    {
        std::vector<T> out;
        size_t slength = subj.size();
        size_t index = 0;

        for(size_t i = 0;i < slength - 1;i++){
            if(quan == subj.at(i+index)){
                if(i != 0){
                    out.emplace_back(subj.substr(index,i));
                }
                
                index += i+1;
                slength -= i+1;
                i = 0;
            }
        }
        if(index < subj.size()){
            out.emplace_back(subj.substr(index));
        }

        return out;
    }
}
#endif