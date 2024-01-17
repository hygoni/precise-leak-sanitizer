# PreciseLeakSanitizer
PreciseLeakSanitizer is a dynamic memory leak detector that can pinpoint where memory is lost, using LLVM pass

# How to build and run

You need LLVM 17 to build this project.

## Build the pass
```bash
$ mkdir build
$ cd build
$ cmake ..
$ make -j$(nproc)
```

## Compile the program with PreciseLeakSanitizer pass
```bash
$ clang -fpass-plugin=`echo build/PreciseLeakSanitizer/PreciseLeakSanitizer.so` <source file>
```

# Documentation
- [Pseudocode for PreciseLeakSanitizer](./Documentation/pseudocode/pseudocode.md)
