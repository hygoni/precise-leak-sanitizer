; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=aggressive-instcombine -S < %s | FileCheck %s --implicit-check-not=llvm.cttz

;; These cases should ensure we are not lowering of some wrong implementations
;; of table-based ctz algorithms to the llvm.cttz instruction.

@ctz1.table = internal unnamed_addr constant [32 x i8] c"\05\01\1C\02\1D\0E\18\03\1E\16\14\0F\19\11\04\08\1F\1B\0D\17\15\13\10\07\1A\0C\12\06\0B\05\0A\09", align 1

;; This is a negative test with a wrong table constant.

define i32 @ctz1(i32 %x) {
entry:
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %mul = mul i32 %and, 125613361
  %shr = lshr i32 %mul, 27
  %idxprom = zext i32 %shr to i64
  %arrayidx = getelementptr inbounds [32 x i8], ptr @ctz1.table, i64 0, i64 %idxprom
  %0 = load i8, ptr %arrayidx, align 1
  %conv = zext i8 %0 to i32
  ret i32 %conv
}

;; These are some negative tests with a wrong instruction sequences.

@ctz2.table = internal unnamed_addr constant [32 x i8] c"\00\01\1C\02\1D\0E\18\03\1E\16\14\0F\19\11\04\08\1F\1B\0D\17\15\13\10\07\1A\0C\12\06\0B\05\0A\09", align 1

define i32 @ctz2(i32 %x) {
entry:
  %sub = sub i32 1, %x
  %and = and i32 %sub, %x
  %mul = mul i32 %and, 125613361
  %shr = lshr i32 %mul, 27
  %idxprom = zext i32 %shr to i64
  %arrayidx = getelementptr inbounds [32 x i8], ptr @ctz2.table, i64 0, i64 %idxprom
  %0 = load i8, ptr %arrayidx, align 1
  %conv = zext i8 %0 to i32
  ret i32 %conv
}

define i32 @ctz3(i32 %x) {
entry:
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %mul = mul i32 %and, 125613362
  %shr = lshr i32 %mul, 27
  %idxprom = zext i32 %shr to i64
  %arrayidx = getelementptr inbounds [32 x i8], ptr @ctz2.table, i64 0, i64 %idxprom
  %0 = load i8, ptr %arrayidx, align 1
  %conv = zext i8 %0 to i32
  ret i32 %conv
}

define i32 @ctz4(i32 %x) {
entry:
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %mul = mul i32 %and, 125613361
  %shr = lshr i32 %mul, 26
  %idxprom = zext i32 %shr to i64
  %arrayidx = getelementptr inbounds [32 x i8], ptr @ctz2.table, i64 0, i64 %idxprom
  %0 = load i8, ptr %arrayidx, align 1
  %conv = zext i8 %0 to i32
  ret i32 %conv
}

;; This is a negative test with a wrong table size and constants.

@ctz3.table = internal unnamed_addr constant [128 x i8] c"\00\01\1C\02\1D\0E\18\03\1E\16\14\0F\19\11\04\08\1F\1B\0D\17\15\13\10\07\1A\0C\12\06\0B\05\0A\09\00\01\1C\02\1D\0E\18\03\1E\16\14\0F\19\11\04\08\1F\1B\0D\17\15\13\10\07\1A\0C\12\06\0B\05\0A\09\00\01\1C\02\1D\0E\18\03\1E\16\14\0F\19\11\04\08\1F\1B\0D\17\15\13\10\07\1A\0C\12\06\0B\05\0A\09\00\01\1C\02\1D\0E\18\03\1E\16\14\0F\19\11\04\08\1F\1B\0D\17\15\13\10\07\1A\0C\12\06\0B\05\0A\09", align 1

define i32 @ctz5(i32 %x) {
entry:
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %mul = mul i32 %and, 125613361
  %shr = lshr i32 %mul, 27
  %idxprom = zext i32 %shr to i64
  %arrayidx = getelementptr inbounds [128 x i8], ptr @ctz3.table, i64 0, i64 %idxprom
  %0 = load i8, ptr %arrayidx, align 1
  %conv = zext i8 %0 to i32
  ret i32 %conv
}

;; A test with an extern global variable representing the table.
;; extern int table[32];
;;
;;  int ctz6(unsigned x) {
;;    if (x == 0) return 32;
;;    x = (x & -x) * 0x04D7651F;
;;    return table[x >> 27];
;;  }

@table = external global [32 x i32], align 16
define i32 @ctz6(i32 noundef %x) {
entry:
  %cmp = icmp eq i32 %x, 0
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %mul = mul i32 %and, 81224991
  %shr = lshr i32 %mul, 27
  %idxprom = zext i32 %shr to i64
  %arrayidx = getelementptr inbounds [32 x i32], ptr @table, i64 0, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4
  br label %return

return:                                           ; preds = %entry, %if.end
  %retval.0 = phi i32 [ %0, %if.end ], [ 32, %entry ]
  ret i32 %retval.0
}

;; We want only constant tables to be considered as CTTZ ones.
;; int indexes[] = {
;;     63, 0, 58, 1, 59, 47, 53, 2,60, 39, 48, 27, 54, 33, 42, 3,
;;     61, 51, 37, 40, 49, 18, 28, 20, 55, 30, 34, 11, 43, 14, 22, 4,
;;     62, 57, 46, 52, 38, 26, 32, 41, 50, 36, 17, 19, 29, 10, 13, 21,
;;     56, 45, 25, 31, 35, 16, 9, 12, 44, 24, 15, 8, 23, 7, 6, 5
;; };
;;
;; int ctz7(unsigned long n)
;; {
;;       return indexes[((n & (~n + 1)) * 0x07EDD5E59A4E28C2ull) >> 58];
;; }

@ctz7.table = global [64 x i32] [i32 63, i32 0, i32 58, i32 1, i32 59, i32 47, i32 53, i32 2, i32 60, i32 39, i32 48, i32 27, i32 54, i32 33, i32 42, i32 3, i32 61, i32 51, i32 37, i32 40, i32 49, i32 18, i32 28, i32 20, i32 55, i32 30, i32 34, i32 11, i32 43, i32 14, i32 22, i32 4, i32 62, i32 57, i32 46, i32 52, i32 38, i32 26, i32 32, i32 41, i32 50, i32 36, i32 17, i32 19, i32 29, i32 10, i32 13, i32 21, i32 56, i32 45, i32 25, i32 31, i32 35, i32 16, i32 9, i32 12, i32 44, i32 24, i32 15, i32 8, i32 23, i32 7, i32 6, i32 5], align 4

define i32 @ctz7(i64 %n) {
entry:
  %add = sub i64 0, %n
  %and = and i64 %add, %n
  %mul = mul i64 %and, 571347909858961602
  %shr = lshr i64 %mul, 58
  %arrayidx = getelementptr inbounds [64 x i32], ptr @ctz7.table, i64 0, i64 %shr
  %0 = load i32, ptr %arrayidx, align 4
  ret i32 %0
}
