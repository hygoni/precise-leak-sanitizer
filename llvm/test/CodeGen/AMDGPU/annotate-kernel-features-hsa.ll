; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -mtriple=amdgcn-unknown-amdhsa -S -amdgpu-annotate-kernel-features < %s | FileCheck -check-prefixes=HSA,AKF_HSA %s
; RUN: opt -mtriple=amdgcn-unknown-amdhsa -S -amdgpu-attributor < %s | FileCheck -check-prefixes=HSA,ATTRIBUTOR_HSA %s

target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5"

declare i32 @llvm.amdgcn.workgroup.id.x() #0
declare i32 @llvm.amdgcn.workgroup.id.y() #0
declare i32 @llvm.amdgcn.workgroup.id.z() #0

declare i32 @llvm.amdgcn.workitem.id.x() #0
declare i32 @llvm.amdgcn.workitem.id.y() #0
declare i32 @llvm.amdgcn.workitem.id.z() #0

declare ptr addrspace(4) @llvm.amdgcn.dispatch.ptr() #0
declare ptr addrspace(4) @llvm.amdgcn.queue.ptr() #0
declare ptr addrspace(4) @llvm.amdgcn.kernarg.segment.ptr() #0
declare ptr addrspace(4) @llvm.amdgcn.implicitarg.ptr() #0

declare i1 @llvm.amdgcn.is.shared(ptr nocapture) #2
declare i1 @llvm.amdgcn.is.private(ptr nocapture) #2

define amdgpu_kernel void @use_tgid_x(ptr addrspace(1) %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_x
; HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1:[0-9]+]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workgroup.id.x()
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_y(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tgid_y
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tgid_y
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR2:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workgroup.id.y()
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @multi_use_tgid_y(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@multi_use_tgid_y
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@multi_use_tgid_y
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR2]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val1, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_x_y(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tgid_x_y
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tgid_x_y
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR2]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_z(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tgid_z
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; AKF_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tgid_z
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR3:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; ATTRIBUTOR_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workgroup.id.z()
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_x_z(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tgid_x_z
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tgid_x_z
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR3]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_y_z(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tgid_y_z
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tgid_y_z
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR4:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.y()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_x_y_z(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tgid_x_y_z
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL2]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tgid_x_y_z
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR4]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL2]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  %val2 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  store volatile i32 %val2, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_x(ptr addrspace(1) %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_x
; HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workitem.id.x()
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_y(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tidig_y
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; AKF_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tidig_y
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR5:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; ATTRIBUTOR_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workitem.id.y()
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_z(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tidig_z
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; AKF_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tidig_z
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR6:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; ATTRIBUTOR_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workitem.id.z()
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_x_tgid_x(ptr addrspace(1) %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_x_tgid_x
; HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.x()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_y_tgid_y(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tidig_y_tgid_y
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tidig_y_tgid_y
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR7:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.y()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_x_y_z(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_tidig_x_y_z
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; AKF_HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL2]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_tidig_x_y_z
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR8:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; ATTRIBUTOR_HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL2]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.x()
  %val1 = call i32 @llvm.amdgcn.workitem.id.y()
  %val2 = call i32 @llvm.amdgcn.workitem.id.z()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  store volatile i32 %val2, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_all_workitems(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_all_workitems
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; AKF_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; AKF_HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; AKF_HSA-NEXT:    [[VAL3:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; AKF_HSA-NEXT:    [[VAL4:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; AKF_HSA-NEXT:    [[VAL5:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; AKF_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL2]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL3]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL4]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    store volatile i32 [[VAL5]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_all_workitems
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR9:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; ATTRIBUTOR_HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; ATTRIBUTOR_HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; ATTRIBUTOR_HSA-NEXT:    [[VAL3:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; ATTRIBUTOR_HSA-NEXT:    [[VAL4:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; ATTRIBUTOR_HSA-NEXT:    [[VAL5:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL0]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL1]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL2]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL3]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL4]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 [[VAL5]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.x()
  %val1 = call i32 @llvm.amdgcn.workitem.id.y()
  %val2 = call i32 @llvm.amdgcn.workitem.id.z()
  %val3 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val4 = call i32 @llvm.amdgcn.workgroup.id.y()
  %val5 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, ptr addrspace(1) %ptr
  store volatile i32 %val1, ptr addrspace(1) %ptr
  store volatile i32 %val2, ptr addrspace(1) %ptr
  store volatile i32 %val3, ptr addrspace(1) %ptr
  store volatile i32 %val4, ptr addrspace(1) %ptr
  store volatile i32 %val5, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_dispatch_ptr(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_dispatch_ptr
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call ptr addrspace(4) @llvm.amdgcn.dispatch.ptr()
; AKF_HSA-NEXT:    [[VAL:%.*]] = load i32, ptr addrspace(4) [[DISPATCH_PTR]], align 4
; AKF_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_dispatch_ptr
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR10:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call ptr addrspace(4) @llvm.amdgcn.dispatch.ptr()
; ATTRIBUTOR_HSA-NEXT:    [[VAL:%.*]] = load i32, ptr addrspace(4) [[DISPATCH_PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %dispatch.ptr = call ptr addrspace(4) @llvm.amdgcn.dispatch.ptr()
  %val = load i32, ptr addrspace(4) %dispatch.ptr
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_queue_ptr(ptr addrspace(1) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_queue_ptr
; AKF_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call ptr addrspace(4) @llvm.amdgcn.queue.ptr()
; AKF_HSA-NEXT:    [[VAL:%.*]] = load i32, ptr addrspace(4) [[DISPATCH_PTR]], align 4
; AKF_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_queue_ptr
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR11:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call ptr addrspace(4) @llvm.amdgcn.queue.ptr()
; ATTRIBUTOR_HSA-NEXT:    [[VAL:%.*]] = load i32, ptr addrspace(4) [[DISPATCH_PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %dispatch.ptr = call ptr addrspace(4) @llvm.amdgcn.queue.ptr()
  %val = load i32, ptr addrspace(4) %dispatch.ptr
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_kernarg_segment_ptr(ptr addrspace(1) %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_kernarg_segment_ptr
; HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call ptr addrspace(4) @llvm.amdgcn.kernarg.segment.ptr()
; HSA-NEXT:    [[VAL:%.*]] = load i32, ptr addrspace(4) [[DISPATCH_PTR]], align 4
; HSA-NEXT:    store i32 [[VAL]], ptr addrspace(1) [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %dispatch.ptr = call ptr addrspace(4) @llvm.amdgcn.kernarg.segment.ptr()
  %val = load i32, ptr addrspace(4) %dispatch.ptr
  store i32 %val, ptr addrspace(1) %ptr
  ret void
}

define amdgpu_kernel void @use_group_to_flat_addrspacecast(ptr addrspace(3) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_group_to_flat_addrspacecast
; AKF_HSA-SAME: (ptr addrspace(3) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[STOF:%.*]] = addrspacecast ptr addrspace(3) [[PTR]] to ptr
; AKF_HSA-NEXT:    store volatile i32 0, ptr [[STOF]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_group_to_flat_addrspacecast
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(3) [[PTR:%.*]]) #[[ATTR11]] {
; ATTRIBUTOR_HSA-NEXT:    [[STOF:%.*]] = addrspacecast ptr addrspace(3) [[PTR]] to ptr
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 0, ptr [[STOF]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %stof = addrspacecast ptr addrspace(3) %ptr to ptr
  store volatile i32 0, ptr %stof
  ret void
}

define amdgpu_kernel void @use_private_to_flat_addrspacecast(ptr addrspace(5) %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_private_to_flat_addrspacecast
; AKF_HSA-SAME: (ptr addrspace(5) [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[STOF:%.*]] = addrspacecast ptr addrspace(5) [[PTR]] to ptr
; AKF_HSA-NEXT:    store volatile i32 0, ptr [[STOF]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_private_to_flat_addrspacecast
; ATTRIBUTOR_HSA-SAME: (ptr addrspace(5) [[PTR:%.*]]) #[[ATTR11]] {
; ATTRIBUTOR_HSA-NEXT:    [[STOF:%.*]] = addrspacecast ptr addrspace(5) [[PTR]] to ptr
; ATTRIBUTOR_HSA-NEXT:    store volatile i32 0, ptr [[STOF]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %stof = addrspacecast ptr addrspace(5) %ptr to ptr
  store volatile i32 0, ptr %stof
  ret void
}

define amdgpu_kernel void @use_flat_to_group_addrspacecast(ptr %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_group_addrspacecast
; HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast ptr [[PTR]] to ptr addrspace(3)
; HSA-NEXT:    store volatile i32 0, ptr addrspace(3) [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast ptr %ptr to ptr addrspace(3)
  store volatile i32 0, ptr addrspace(3) %ftos
  ret void
}

define amdgpu_kernel void @use_flat_to_private_addrspacecast(ptr %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_private_addrspacecast
; HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast ptr [[PTR]] to ptr addrspace(5)
; HSA-NEXT:    store volatile i32 0, ptr addrspace(5) [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast ptr %ptr to ptr addrspace(5)
  store volatile i32 0, ptr addrspace(5) %ftos
  ret void
}

; No-op addrspacecast should not use queue ptr
define amdgpu_kernel void @use_global_to_flat_addrspacecast(ptr addrspace(1) %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_global_to_flat_addrspacecast
; HSA-SAME: (ptr addrspace(1) [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[STOF:%.*]] = addrspacecast ptr addrspace(1) [[PTR]] to ptr
; HSA-NEXT:    store volatile i32 0, ptr [[STOF]], align 4
; HSA-NEXT:    ret void
;
  %stof = addrspacecast ptr addrspace(1) %ptr to ptr
  store volatile i32 0, ptr %stof
  ret void
}

define amdgpu_kernel void @use_constant_to_flat_addrspacecast(ptr addrspace(4) %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_constant_to_flat_addrspacecast
; HSA-SAME: (ptr addrspace(4) [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[STOF:%.*]] = addrspacecast ptr addrspace(4) [[PTR]] to ptr
; HSA-NEXT:    [[LD:%.*]] = load volatile i32, ptr [[STOF]], align 4
; HSA-NEXT:    ret void
;
  %stof = addrspacecast ptr addrspace(4) %ptr to ptr
  %ld = load volatile i32, ptr %stof
  ret void
}

define amdgpu_kernel void @use_flat_to_global_addrspacecast(ptr %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_global_addrspacecast
; HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast ptr [[PTR]] to ptr addrspace(1)
; HSA-NEXT:    store volatile i32 0, ptr addrspace(1) [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast ptr %ptr to ptr addrspace(1)
  store volatile i32 0, ptr addrspace(1) %ftos
  ret void
}

define amdgpu_kernel void @use_flat_to_constant_addrspacecast(ptr %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_constant_addrspacecast
; HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast ptr [[PTR]] to ptr addrspace(4)
; HSA-NEXT:    [[LD:%.*]] = load volatile i32, ptr addrspace(4) [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast ptr %ptr to ptr addrspace(4)
  %ld = load volatile i32, ptr addrspace(4) %ftos
  ret void
}

define amdgpu_kernel void @use_is_shared(ptr %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_is_shared
; AKF_HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[IS_SHARED:%.*]] = call i1 @llvm.amdgcn.is.shared(ptr [[PTR]])
; AKF_HSA-NEXT:    [[EXT:%.*]] = zext i1 [[IS_SHARED]] to i32
; AKF_HSA-NEXT:    store i32 [[EXT]], ptr addrspace(1) undef, align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_is_shared
; ATTRIBUTOR_HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR11]] {
; ATTRIBUTOR_HSA-NEXT:    [[IS_SHARED:%.*]] = call i1 @llvm.amdgcn.is.shared(ptr [[PTR]])
; ATTRIBUTOR_HSA-NEXT:    [[EXT:%.*]] = zext i1 [[IS_SHARED]] to i32
; ATTRIBUTOR_HSA-NEXT:    store i32 [[EXT]], ptr addrspace(1) undef, align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %is.shared = call i1 @llvm.amdgcn.is.shared(ptr %ptr)
  %ext = zext i1 %is.shared to i32
  store i32 %ext, ptr addrspace(1) undef
  ret void
}

define amdgpu_kernel void @use_is_private(ptr %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_is_private
; AKF_HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR1]] {
; AKF_HSA-NEXT:    [[IS_PRIVATE:%.*]] = call i1 @llvm.amdgcn.is.private(ptr [[PTR]])
; AKF_HSA-NEXT:    [[EXT:%.*]] = zext i1 [[IS_PRIVATE]] to i32
; AKF_HSA-NEXT:    store i32 [[EXT]], ptr addrspace(1) undef, align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_is_private
; ATTRIBUTOR_HSA-SAME: (ptr [[PTR:%.*]]) #[[ATTR11]] {
; ATTRIBUTOR_HSA-NEXT:    [[IS_PRIVATE:%.*]] = call i1 @llvm.amdgcn.is.private(ptr [[PTR]])
; ATTRIBUTOR_HSA-NEXT:    [[EXT:%.*]] = zext i1 [[IS_PRIVATE]] to i32
; ATTRIBUTOR_HSA-NEXT:    store i32 [[EXT]], ptr addrspace(1) undef, align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %is.private = call i1 @llvm.amdgcn.is.private(ptr %ptr)
  %ext = zext i1 %is.private to i32
  store i32 %ext, ptr addrspace(1) undef
  ret void
}

define amdgpu_kernel void @use_alloca() #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_alloca
; AKF_HSA-SAME: () #[[ATTR2:[0-9]+]] {
; AKF_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; AKF_HSA-NEXT:    store i32 0, ptr addrspace(5) [[ALLOCA]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_alloca
; ATTRIBUTOR_HSA-SAME: () #[[ATTR1]] {
; ATTRIBUTOR_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; ATTRIBUTOR_HSA-NEXT:    store i32 0, ptr addrspace(5) [[ALLOCA]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %alloca = alloca i32, addrspace(5)
  store i32 0, ptr addrspace(5) %alloca
  ret void
}

define amdgpu_kernel void @use_alloca_non_entry_block() #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_alloca_non_entry_block
; AKF_HSA-SAME: () #[[ATTR2]] {
; AKF_HSA-NEXT:  entry:
; AKF_HSA-NEXT:    br label [[BB:%.*]]
; AKF_HSA:       bb:
; AKF_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; AKF_HSA-NEXT:    store i32 0, ptr addrspace(5) [[ALLOCA]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_alloca_non_entry_block
; ATTRIBUTOR_HSA-SAME: () #[[ATTR1]] {
; ATTRIBUTOR_HSA-NEXT:  entry:
; ATTRIBUTOR_HSA-NEXT:    br label [[BB:%.*]]
; ATTRIBUTOR_HSA:       bb:
; ATTRIBUTOR_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; ATTRIBUTOR_HSA-NEXT:    store i32 0, ptr addrspace(5) [[ALLOCA]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
entry:
  br label %bb

bb:
  %alloca = alloca i32, addrspace(5)
  store i32 0, ptr addrspace(5) %alloca
  ret void
}

define void @use_alloca_func() #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_alloca_func
; AKF_HSA-SAME: () #[[ATTR2]] {
; AKF_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; AKF_HSA-NEXT:    store i32 0, ptr addrspace(5) [[ALLOCA]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_alloca_func
; ATTRIBUTOR_HSA-SAME: () #[[ATTR12:[0-9]+]] {
; ATTRIBUTOR_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; ATTRIBUTOR_HSA-NEXT:    store i32 0, ptr addrspace(5) [[ALLOCA]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %alloca = alloca i32, addrspace(5)
  store i32 0, ptr addrspace(5) %alloca
  ret void
}

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { nounwind }

;.
; AKF_HSA: attributes #[[ATTR0:[0-9]+]] = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
; AKF_HSA: attributes #[[ATTR1]] = { nounwind }
; AKF_HSA: attributes #[[ATTR2]] = { nounwind "amdgpu-stack-objects" }
;.
; ATTRIBUTOR_HSA: attributes #[[ATTR0:[0-9]+]] = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
; ATTRIBUTOR_HSA: attributes #[[ATTR1]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR2]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR3]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR4]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR5]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR6]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR7]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR8]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR9]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workitem-id-x" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR10]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR11]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR12]] = { nounwind "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "amdgpu-waves-per-eu"="4,10" "uniform-work-group-size"="false" }
;.
