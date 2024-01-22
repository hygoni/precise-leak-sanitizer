# Pseudocode for PreciseLeakSanitizer

This document specifies pseudocode for the implementation of PreciseLeakSanitizer. It is a memory leak detector that can find memory leaks at runtime similar to [the leak sanitizer in LLVM and GCC](https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer). It is designed to pinpoint where the process lost its last reference efficiently.

## Table of Contents
1. [Minimum alignment for allocation](#1-minimum-alignment-for-allocation)
2. [Reference Count Encoding](#2-reference-count-encoding)   
	- 2.1 [Initializing reference count](#21-initializing-reference-count)  
	- 2.2 [Converting a virtual address to reference count](#22-converting-a-virtual-address-to-reference-count)  
3. [mmap()ing Reference Counting Address Space](#3-mmaping-reference-counting-address-space)
4. [Tracking reference count of a buffer](#4-tracking-reference-count-of-a-buffer)  
	- 4.1 [When reference count is incremented](#41-when-reference-count-is-incremented)  
	- 4.2 [When reference count is decremented](#42-when-reference-count-is-decremented)  
	- 4.3 [More considerations and optimizations](#43-more-considerations-and-optimizations)  
        - 4.3.1 [When a function exits](#431-when-a-function-exits)  
        - 4.3.2 [Freed pointer variables either on heap or on stack should be initialized to NULL](#432-freed-pointer-variables-either-on-the-heap-or-on-the-stack-should-be-initialized-to-null)  
        - 4.3.3 [Not instrumenting when storing to stack variables](#433-not-instrumenting-when-storing-to-stack-variables)    
5. [Report a memory leak](#5-reporting-a-memory-leak)
    - [5.2 Storing stack backtrace when memory is allocated](#51-storing-stack-backtrace-when-memory-is-allocated)

## 1. Minimum alignment for allocation
To ensure shadow memory work correctly, the size of each allocation must be aligned to a specific size. For reduced address space overhead, **we align the allocation size to 16 bytes.** This means that the size argument of malloc(), realloc(), calloc(), new and new[] must be aligned before calling these functions. **Note: If the size is not a constant, it should be replaced with an appropriate instruction, rather than a fixed constant.**

## 2. Reference Count Encoding
For every 16 bytes of address space, we allocate a byte for reference count. It is based on the assumption that **the number of references to a buffer does not exceed 127.** This concept is similar to the **shadow memory** used in AddressSanitizer, thus we use the terms **reference count address space** and **shadow memory** interchangeably. When the size exceeds 16, the additional reference counts become redundant as only one reference count is utilized per buffer.

While this method may lead to a maximum waste of 4095 bytes of memory for reference counts per object, it significantly speeds up the conversion of a virtual address to a reference count address. Moreover, allocating objects larger than 4K bytes is generally a rare occurrence.

The formula for virtual address to corresponding shadow memory address is as follows:
```math
refcnt\_addr = (start\ address\ of\ refcnt\ space) + \frac{(virtual\ address\ of\ a\ buffer)} {16}
```

Which translates to a couple of instructions. However, the formula above is slightly misleading, as there is only one reference count for a buffer. When the size is larger than 16 bytes, then rest of the reference counts point to the first reference count by storing the offset from the first reference count as a negative value.

### 2.1 Initializing reference count
Initialization of reference count is as follows:
```c
when one of malloc(), calloc(), realloc() or new, new[] is called:
int8_t *refcnt_addr = refcnt_start + (buffer's address) / 16
*refcnt_addr = 127;
for (int i = 1; i < size / 16; i++) {
    if (i <= 127)
        (refcnt_addr + i) = -(int8_t)i;
    else
        (refcnt_addr + i) = -128;
}
```

Visually, reference counts are initialize like figure below. Note that in case where size is bigger than 128 * 16, storing -128 is ok because the first reference count is still reachable.

<p align="center">
<img src="./images/reference-count.png" alt="reference count figure" width="600px"/>
</p>

### 2.2 Converting a virtual address to reference count
```c
/* @addr might be in the middle of a buffer */
uint8_t *addr_to_refcnt_addr(void *addr)
{
     int8_t *refcnt_addr = refcnt_start + ((unsigned long long)addr) / 16;
     while (*refcnt_addr < 0) {
         refcnt_addr += *refcnt_addr;
     }
     return refcnt_addr;
}
```

## 3. mmap()ing Reference Counting Address Space
Note: For any uncertanities, always refer to [the mmap() manual](https://man7.org/linux/man-pages/man2/mmap.2.html).

For reference counts, we use 1/16 of virtual address space of a process. Allocating an address space is done via mmap() system call in unix-like operating systems. Here we use the word **address space** and **mapping** interchangeably.

More specifically, we allocate **anonymous mapping (MAP_ANONYMOUS)** as opposed **file-backed mapping**, simply because it is not backed by any file. Also, the mapping is **private (MAP_PRIVATE)** because it is not shared between processes.

By the way 1/16 of total address space is huge size, as operating systems usually does not allow allocating much larger virtual address space than . Read [memory overcommit](https://en.wikipedia.org/wiki/Memory_overcommitment) for more detail; In short, **you need to pass MAP_NORESERVE** flag to mmap() to avoid issues on allocating very large address space.

<p align="center">
<img src="./images/shadow-memory.png" alt="shadow memory" width="600px"/>
</p>

## 4. Tracking reference count of a buffer

As explained in [2.1 Initializing reference count](#21-initializing-reference-count) section, the reference count is initialized when allocating memory. Reference count is incremented or decremented, but when it reaches zero, generally it is a memory leak. But there are few exceptions on this. Read [section 4.3.1](#431-when-a-function-exits) for more details.

### 4.1 When reference count is incremented
Reference count is incremented when:

1. Storing the value of a pointer to another variable.
2. Copying memory to memory using memcpy(), memmove() or etc.

### 4.2 When reference count is decremented
Reference count is decremented when:

1. Overwriting a pointer variable with another value.
2. When memory is overwritten by memcpy(), memset(), memmove() etc.
3. **When freeing an object** that refers to other objects. In this case, of course, you need to search pointers inside the object every time one of free(), delete or delete[] is called.
4. **When a function exits**, its local variables are automatically freed. so you need to decrement the reference count of buffers that local variables point to.

### 4.3 More considerations and optimizations

#### 4.3.1 When a function exits

As stated in [section 4.2](#42-when-reference-count-is-decremented), local variables are automatically freed at function exit and thus the reference count of buffers referenced by local pointer variables should be decremented.

However, even if the reference count becomes zero, it might not be a memory leak if the pointer is the return value of a function. In that case, it is possible that the pointer value is written back to memory.

Let's consider the following code:

```c
void *malloc_wrapper(size_t size)
{
    void *ptr = malloc(size);
    return ptr;
}

void foo()
{
    void *foo = malloc_wrapper(10);
    [...]
}
```

When malloc_wrapper() exits, the reference count of the buffer becomes zero because the lifetime of ptr ends when the function exits. But in foo(), the pointer value is written back to memory. So if reference count becomes zero because of local variable's lifetime is ended, it might not be a memory leak.

Similarly, the return value of malloc() might never be written to memory. In both cases, we need to check if the return value is written to memory after the function exits.

```c
void foo()
{
    malloc(10);
    [...]
}
```

The solution for both situation is to check if the pointer is written to memory after a function call, or the pointer value is return value of current function (the caller of malloc(), for example)

#### The solution to this problem

If the returned pointer is utilized by StoreInst or ReturnInst, a call to **checkReturnedOrStoredValue()** function is inserted.

To achieve this, the LLVM pass must traverse all users that utilize the return value of a CallInst (and check if is StoreInst or ReturnInst). It is assumed that **StoreInst that utilizes return value of a CallInst must be within the same BasicBlock.** Also, **if the return value is returned without StoreInst, it is assumed that the ReturnInst must be within the same Basic Block.** Therefore it is enough to traverse users only within the BasicBlock of the CallInst.

```c
// Checks if correct pointer value is stored or returned
void checkReturnedOrStoredValue(void *RetPtrAddr, void *ComparePtrAddr) {
    void *RetPtrRefAddr = addr_to_refcnt(RetPtrAddr);
    void *CompareRefPtrAddr = addr_to_refcnt(ComparePtrAddr);

    if (*RetPtrRefAddr <= 0) {
        return;
    } else if (RetPtrRefAddr != CompareRefPtrAddr) {
        Error();
    }
}
```

If the pointer value returned by the CallInst is not utilized by StoreInst nor ReturnInst within the same BasicBlock, it is obviously a memory leak. In that case, reportMemoryLeak() function should be called.

```c
/*
    A call to this function is inserted after a CallInst if the pointer
    returned by the CallInst is not utilized. It can be possible
    that the pointer does not reference heap space, so need to check
    that first.

    If 1) it references heap and 2) the reference count is zero, it is
    obviously a memory leak.
*/
void reportMemoryLeak(void *RetPtrAddr) {
    void *RetPtrRefAddr = addr_to_refcnt(RetPtrAddr);
    /* RetPtrAddr reference heap space and the reference count is zero */
    if (*RetPtrRef == 127) {
        Error();
    }
}
```

Again, reportMemoryLeak() is inserted after CallInst **when the function's return type is pointer AND there's no StoreInst or ReturnInst utilizes the return value.** It can be possible that the return pointer does not refer heap address space, so need to check that first. In the future this can be optimized further, but this is the current approach so far.

#### Pseudocode

Pseudocode when a function exits (at runtime):  
**This routine should be inserted to _every_ ReturnInst of a function**

```c
decrement reference counts of buffers that local variables reference
if any buffer's reference count drop to zero:
  if the buffer's address is the return value of current function:
    do nothing, just return
  else:
    report a memory leak with the information on the local variable
else:
  do nothing, just return

```
Pseudocode when calling a function (in the LLVM pass)  
**For any CallInst**:

```c
if the function's return type is a pointer:
  traverse all users of the return value, in the BasicBlock of the CallInst
  if there is any StoreInst or ReturnInst in the users:
    insert a CallInst to checkReturnedOrStoredValue() before the user
  else:
    insert a CallInst to reportMemoryLeak() after the CallInst
```

#### 4.3.2 Freed pointer variables (either on the heap or on the stack) should be initialized to NULL

If any pointer variable is freed (either a variable on the stack or on the heap), it must be initialized to NULL. This is because the PreciseLeakDetector can malfunction when it stores data to an uninitialized variable.

Let's look at an example:

```c
void foo(void *addr)
{
    void *p =  addr;
}

int main(void)
{
  void *ptr = malloc(10);

  foo(ptr);
  foo(NULL);
}
```

<p align="center">
<img src="./images/calling-foo-the-first-time.png" alt="calling foo() the first time" width="600px"/>
</p>

Just before calling foo() in main(), the reference count of the buffer is 1. After calling foo() the first time, the reference count should still be 1 when foo() exits.

<p align="center">
<img src="./images/calling-foo-the-second-time.png" alt="calling foo() the second time" width="600px"/>
</p>

But on the second time foo() is called, the reference count might become zero because the uninitialized value of p is still a valid pointer. That's why every pointer variable needs to be initialized to zero when it's freed.

This applies to heap objects in the same manner. Basically when free() is called, PLSAN must scan the freed object to find valid pointers within the freed object, and then it decrements reference counts of buffers referenced by such pointers as explained in the [section 4.2](#42-when-reference-count-is-decremented). After decrementing a reference count, the pointer should be set to NULL for the same reason as pointer variables on the stack.

#### 4.3.3 Not instrumenting when storing to stack variables
I believe it is possible to avoid instrumenting StoreInsts for local variables, but need to think more about it.

### 5. Reporting a memory leak

Let's look at what the report by PLSAN would look like. Below is an example program with a memory leak:

```c
   1   │ #include <stdlib.h>
   2   │
   3   │ int main(void)
   4   │ {
   5   │   void *ptr = malloc(10);
   6   │
   7   │   ptr = NULL;
   8   │
   9   │   return 0;
  10   │ }
```

The report will look like this:

```bash
=================================================================
==<Process Number>==ERROR: PreciseLeakSanitizer: detected memory leaks

Leak of 10 byte(s) in an object (<address of the object>) allocated from:
    #1 0x401137 in main /home/hyeyoo/precise-leak-sanitizer/main.c:5
    #2 0x7fd7dd83feaf in __libc_start_call_main (/lib64/libc.so.6+0x3feaf)

Last reference to the object (<address of the object>) lost at:
    #1 0x401150 in main /home/hyeyoo/precise-leak-sanitizer/main.c:7
    #2 0x7fd7dd83feaf in __libc_start_call_main (/lib64/libc.so.6+0x3feaf)
```

It shows 1) **where the object is allocated** and 2) **where the last reference to it is lost.** To show where it is allocated, PLSAN should store stack backtrace when a memory allocation function is called. Printing stack backtrace when the last reference to the object is lost is done by printing it immediately.

## 5.1 Storing stack backtrace when memory is allocated

It is worth noting that **deduplication matters** when the number of allocated memory blocks is huge. de-duplication generally means avoiding duplication of data. For PLSAN, it means not storing the same stack backtrace more than once. It matters for PLSAN because it is extremely common to allocate objects several times, in the same call path.

KASAN (Kernel ASAN) has similar deduplication mechanism called [stackdepot](https://elixir.bootlin.com/linux/v6.8-rc1/source/lib/stackdepot.c) and I (the author, Hyeonggon) am pretty sure ASAN has similar deduplication mechanism. It would be unnecessary to implement our own deduplication mechanism if we implement PLSAN as a [static plugin](https://github.com/banach-space/llvm-tutor?tab=readme-ov-file#dynamic-vs-static-plugins) because we may utilize what's already in LLVM, but before we start porting PLSAN to LLVM we need our own implementation.

One idea for deduplication is to have to two maps (either hashmap or treemap): one that converts 1) object address to a unique ID (possibly hash value of stack backtrace), and the other that converts the unique ID to actual stack backtrace.