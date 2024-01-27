struct Foo {
  int foo() = delete;
  int bar();
  Foo() = delete;
  Foo(int);
};


// RUN: c-index-test -test-print-type --std=c++11 %s | FileCheck %s
// CHECK: StructDecl=Foo:1:8 (Definition) [type=Foo] [typekind=Record] [isPOD=1]
// CHECK: CXXMethod=foo:2:7 (unavailable) (deleted) [type=int (){{.*}}] [typekind=FunctionProto] [resulttype=int] [resulttypekind=Int] [isPOD=0]
// CHECK: CXXMethod=bar:3:7 [type=int (){{.*}}] [typekind=FunctionProto] [resulttype=int] [resulttypekind=Int] [isPOD=0]
// CHECK: CXXConstructor=Foo:4:3 (unavailable) (default constructor) (deleted) [type=void (){{.*}}] [typekind=FunctionProto] [resulttype=void] [resulttypekind=Void] [isPOD=0]
// CHECK: CXXConstructor=Foo:5:3 (converting constructor) [type=void (int){{.*}}] [typekind=FunctionProto] [resulttype=void] [resulttypekind=Void] [args= [int] [Int]] [isPOD=0]
