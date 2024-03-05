# PreciseLeakSanitizer
PreciseLeakSanitizer is a dynamic memory leak detector that can pinpoint where memory is lost, using LLVM pass

# How to build and run

You need LLVM 17 to build this project.

## Build LLVM, Clang and compiler-rt
```bash
$ mkdir build
$ cd build
$ cmake -DLLVM_ENABLE_PROJECTS="llvm;clang;compiler-rt" \
        -DCMAKE_BUILD_TYPE=Release \
        -G "Unix Makefiles" \
        ../llvm
$ make -j$(nproc)
```

## Compile the program with -fsanitize=precise-leak

Just as other sanitizers, passing -fsanitize=precise-leak option enables PreciseLeakSanitizer. PreciseLeakSanitizer automatically enables LeakSanitizer, but it is not intended to be ran with any other sanitizers other than LeakSanitizer. Use clang or clang++ depending on which language you use.


```bash
$ ./build/bin/clang -fsanitize=precise-leak <source file>
```

# Before committing code to the repository
To check if your code follows right coding style, run scripts/check-coding-style.sh. Or you can execute script/apply-coding-style.sh that automatically adjusts your code to follow the style. (clang-format command is required)

# Documentation
- [Pseudocode for PreciseLeakSanitizer](./Documentation/pseudocode/pseudocode.md)
