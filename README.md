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

# Before committing code to the repository
To check if your code follows right coding style, run scripts/check-coding-style.sh. Or you can execute script/apply-coding-style.sh that automatically adjusts your code to follow the style. (clang-format command is required)

# Documentation
- [Pseudocode for PreciseLeakSanitizer](./Documentation/pseudocode/pseudocode.md)
