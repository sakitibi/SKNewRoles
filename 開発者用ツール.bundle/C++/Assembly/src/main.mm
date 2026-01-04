#import <iostream>
#import <Foundation/Foundation.h>
#include "AssemblyC++.hpp"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        const int Error = Assembly();
        if(Error){
            return 1;
        } else {
            return 0;
        }
    }
}
