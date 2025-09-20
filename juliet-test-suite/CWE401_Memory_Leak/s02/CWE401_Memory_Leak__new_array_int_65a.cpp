/* TEMPLATE GENERATED TESTCASE FILE
Filename: CWE401_Memory_Leak__new_array_int_65a.cpp
Label Definition File: CWE401_Memory_Leak__new_array.label.xml
Template File: sources-sinks-65a.tmpl.cpp
*/
/*
 * @description
 * CWE: 401 Memory Leak
 * BadSource:  Allocate data using new[]
 * GoodSource: Point data to a stack buffer
 * Sinks:
 *    GoodSink: call delete[] on data
 *    BadSink : no deallocation of data
 * Flow Variant: 65 Data/control flow: data passed as an argument from one function to a function in a different source file called via a function pointer
 *
 * */

#include "std_testcase.h"

#ifndef _WIN32
#include <wchar.h>
#endif

namespace CWE401_Memory_Leak__new_array_int_65
{

#ifndef OMITBAD

/* bad function declaration */
void badSink(int * data);

void bad()
{
    int * data;
    /* define a function pointer */
    void (*funcPtr) (int *) = badSink;
    data = NULL;
    /* POTENTIAL FLAW: Allocate memory on the heap */
    data = new int[100];
    /* Initialize and make use of data */
    data[0] = 5;
    printIntLine(data[0]);
    /* use the function pointer */
    funcPtr(data);
}

#endif /* OMITBAD */

#ifndef OMITGOOD

/* goodG2B uses the GoodSource with the BadSink */
void goodG2BSink(int * data);

static void goodG2B()
{
    int * data;
    void (*funcPtr) (int *) = goodG2BSink;
    data = NULL;
    /* FIX: Use memory allocated on the stack */
    int dataGoodBuffer[100];
    data = dataGoodBuffer;
    /* Initialize and make use of data */
    data[0] = 5;
    printIntLine(data[0]);
    funcPtr(data);
}

/* goodB2G uses the BadSource with the GoodSink */
void goodB2GSink(int * data);

static void goodB2G()
{
    int * data;
    void (*funcPtr) (int *) = goodB2GSink;
    data = NULL;
    /* POTENTIAL FLAW: Allocate memory on the heap */
    data = new int[100];
    /* Initialize and make use of data */
    data[0] = 5;
    printIntLine(data[0]);
    funcPtr(data);
}

void good()
{
    goodG2B();
    goodB2G();
}

#endif /* OMITGOOD */

} /* close namespace */

/* Below is the main(). It is only used when building this testcase on
   its own for testing or for building a binary to use in testing binary
   analysis tools. It is not used when compiling all the testcases as one
   application, which is how source code analysis tools are tested. */

#ifdef INCLUDEMAIN

using namespace CWE401_Memory_Leak__new_array_int_65; /* so that we can use good and bad easily */

int main(int argc, char * argv[])
{
    /* seed randomness */
    srand( (unsigned)time(NULL) );
#ifndef OMITGOOD
    printLine("Calling good()...");
    good();
    printLine("Finished good()");
#endif /* OMITGOOD */
#ifndef OMITBAD
    printLine("Calling bad()...");
    bad();
    printLine("Finished bad()");
#endif /* OMITBAD */
    return 0;
}

#endif
