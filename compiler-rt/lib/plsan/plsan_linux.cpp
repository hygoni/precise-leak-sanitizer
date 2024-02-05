//=-- plsan_linux.cpp
//------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of PreciseLeakSanitizer. Linux/NetBSD/Fuchsia-specific
// code.
//
//===----------------------------------------------------------------------===//

#include "sanitizer_common/sanitizer_platform.h"

#if SANITIZER_LINUX || SANITIZER_NETBSD || SANITIZER_FUCHSIA

#include "plsan_allocator.h"
#include "plsan_thread.h"

namespace __plsan {

static THREADLOCAL ThreadContextPlsanBase *current_thread = nullptr;
ThreadContextPlsanBase *GetCurrentThread() { return current_thread; }
void SetCurrentThread(ThreadContextPlsanBase *tctx) { current_thread = tctx; }

static THREADLOCAL AllocatorCache allocator_cache;
AllocatorCache *GetAllocatorCache() { return &allocator_cache; }

void ReplaceSystemMalloc() {}

} // namespace __plsan

#endif // SANITIZER_LINUX || SANITIZER_NETBSD || SANITIZER_FUCHSIA
