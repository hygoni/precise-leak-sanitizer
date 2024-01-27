// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// REQUIRES: amdgpu-registered-target
// RUN: %clang_cc1 -triple amdgcn-unknown-unknown -target-cpu gfx1100 -DWMMA_GFX1100_TESTS -S -emit-llvm -o - %s | FileCheck %s --check-prefix=CHECK-GFX1100

typedef float  v4f   __attribute__((ext_vector_type(4)));
typedef float  v8f   __attribute__((ext_vector_type(8)));
typedef half   v16h  __attribute__((ext_vector_type(16)));
typedef int    v2i   __attribute__((ext_vector_type(2)));
typedef int    v4i   __attribute__((ext_vector_type(4)));
typedef int    v8i   __attribute__((ext_vector_type(8)));
typedef short  v16s  __attribute__((ext_vector_type(16)));

#ifdef WMMA_GFX1100_TESTS

// Wave32

//
// amdgcn_wmma_f32_16x16x16_f16
//

// CHECK-GFX1100-LABEL: @test_amdgcn_wmma_f32_16x16x16_f16_w32(
// CHECK-GFX1100-NEXT:  entry:
// CHECK-GFX1100-NEXT:    [[TMP0:%.*]] = tail call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.f16.v8f32(<16 x half> [[A:%.*]], <16 x half> [[B:%.*]], <8 x float> [[C:%.*]])
// CHECK-GFX1100-NEXT:    store <8 x float> [[TMP0]], ptr addrspace(1) [[OUT:%.*]], align 32, !tbaa [[TBAA4:![0-9]+]]
// CHECK-GFX1100-NEXT:    ret void
//
void test_amdgcn_wmma_f32_16x16x16_f16_w32(global v8f* out, v16h a, v16h b, v8f c)
{
  *out = __builtin_amdgcn_wmma_f32_16x16x16_f16_w32(a, b, c);
}

//
// amdgcn_wmma_f32_16x16x16_bf16
//

// CHECK-GFX1100-LABEL: @test_amdgcn_wmma_f32_16x16x16_bf16_w32(
// CHECK-GFX1100-NEXT:  entry:
// CHECK-GFX1100-NEXT:    [[TMP0:%.*]] = tail call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32(<16 x i16> [[A:%.*]], <16 x i16> [[B:%.*]], <8 x float> [[C:%.*]])
// CHECK-GFX1100-NEXT:    store <8 x float> [[TMP0]], ptr addrspace(1) [[OUT:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-GFX1100-NEXT:    ret void
//
void test_amdgcn_wmma_f32_16x16x16_bf16_w32(global v8f* out, v16s a, v16s b, v8f c)
{
  *out = __builtin_amdgcn_wmma_f32_16x16x16_bf16_w32(a, b, c);
}

//
// amdgcn_wmma_f16_16x16x16_f16
//

// CHECK-GFX1100-LABEL: @test_amdgcn_wmma_f16_16x16x16_f16_w32(
// CHECK-GFX1100-NEXT:  entry:
// CHECK-GFX1100-NEXT:    [[TMP0:%.*]] = tail call <16 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v16f16(<16 x half> [[A:%.*]], <16 x half> [[B:%.*]], <16 x half> [[C:%.*]], i1 true)
// CHECK-GFX1100-NEXT:    store <16 x half> [[TMP0]], ptr addrspace(1) [[OUT:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-GFX1100-NEXT:    ret void
//
void test_amdgcn_wmma_f16_16x16x16_f16_w32(global v16h* out, v16h a, v16h b, v16h c)
{
  *out = __builtin_amdgcn_wmma_f16_16x16x16_f16_w32(a, b, c, true);
}

//
// amdgcn_wmma_bf16_16x16x16_bf16
//

// CHECK-GFX1100-LABEL: @test_amdgcn_wmma_bf16_16x16x16_bf16_w32(
// CHECK-GFX1100-NEXT:  entry:
// CHECK-GFX1100-NEXT:    [[TMP0:%.*]] = tail call <16 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v16i16(<16 x i16> [[A:%.*]], <16 x i16> [[B:%.*]], <16 x i16> [[C:%.*]], i1 true)
// CHECK-GFX1100-NEXT:    store <16 x i16> [[TMP0]], ptr addrspace(1) [[OUT:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-GFX1100-NEXT:    ret void
//
void test_amdgcn_wmma_bf16_16x16x16_bf16_w32(global v16s* out, v16s a, v16s b, v16s c)
{
  *out = __builtin_amdgcn_wmma_bf16_16x16x16_bf16_w32(a, b, c, true);
}

//
// amdgcn_wmma_i32_16x16x16_iu8
//

// CHECK-GFX1100-LABEL: @test_amdgcn_wmma_i32_16x16x16_iu8_w32(
// CHECK-GFX1100-NEXT:  entry:
// CHECK-GFX1100-NEXT:    [[TMP0:%.*]] = tail call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32(i1 true, <4 x i32> [[A:%.*]], i1 true, <4 x i32> [[B:%.*]], <8 x i32> [[C:%.*]], i1 false)
// CHECK-GFX1100-NEXT:    store <8 x i32> [[TMP0]], ptr addrspace(1) [[OUT:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-GFX1100-NEXT:    ret void
//
void test_amdgcn_wmma_i32_16x16x16_iu8_w32(global v8i* out, v4i a, v4i b, v8i c)
{
  *out = __builtin_amdgcn_wmma_i32_16x16x16_iu8_w32(true, a, true, b, c, false);
}

//
// amdgcn_wmma_i32_16x16x16_iu4
//

// CHECK-GFX1100-LABEL: @test_amdgcn_wmma_i32_16x16x16_iu4_w32(
// CHECK-GFX1100-NEXT:  entry:
// CHECK-GFX1100-NEXT:    [[TMP0:%.*]] = tail call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32(i1 true, <2 x i32> [[A:%.*]], i1 true, <2 x i32> [[B:%.*]], <8 x i32> [[C:%.*]], i1 false)
// CHECK-GFX1100-NEXT:    store <8 x i32> [[TMP0]], ptr addrspace(1) [[OUT:%.*]], align 32, !tbaa [[TBAA4]]
// CHECK-GFX1100-NEXT:    ret void
//
void test_amdgcn_wmma_i32_16x16x16_iu4_w32(global v8i* out, v2i a, v2i b, v8i c)
{
  *out = __builtin_amdgcn_wmma_i32_16x16x16_iu4_w32(true, a, true, b, c, false);
}

#endif
