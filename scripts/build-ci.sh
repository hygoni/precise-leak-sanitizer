#!/bin/bash

# 1. Make build folder
mkdir build
cd build

# 2. Build
cmake -DLLVM_ENABLE_PROJECTS="llvm;clang;compiler-rt" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCOMPILER_RT_STACK_UNWIND=ON \
        -G "Unix Makefiles" \
        -DCMAKE_C_COMPILER="/usr/lib/ccache/gcc" \
        -DCMAKE_CXX_COMPILER="/usr/lib/ccache/g++" \
        ../llvm
make -j$(nproc)
