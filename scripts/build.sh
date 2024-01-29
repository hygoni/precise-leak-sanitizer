#!/bin/bash

# 1. Make build folder
mkdir build
cd build

# 2. Build
cmake -DLLVM_ENABLE_PROJECTS="llvm;clang;compiler-rt" \
        -DCMAKE_BUILD_TYPE=Release \
        -G "Unix Makefiles" \
        ../llvm
make -j$(nproc)
