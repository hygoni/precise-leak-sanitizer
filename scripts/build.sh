#!/bin/bash

# 1. Make build folder
mkdir build
cd build

# 2. Build
cmake ..
make -j$(nproc)