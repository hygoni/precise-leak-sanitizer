/* TEMPLATE GENERATED TESTCASE FILE
Filename: CWE401_Memory_Leak__new_twoIntsStruct_67a.cpp
Label Definition File: CWE401_Memory_Leak__new.label.xml
Template File: sources-sinks-67a.tmpl.cpp
*/
/*
 * @description
 * CWE: 401 Memory Leak
 * BadSource:  Allocate data using new
 * GoodSource: Allocate data on the stack
 * Sinks:
 *    GoodSink: call delete on data
 *    BadSink : no deallocation of data
 * Flow Variant: 67 Data flow: data passed in a struct from one function to another in different source files
 *
 * */

#include "std_testcase.h"

#ifndef _WIN32
#include <wchar.h>
#endif

namespace CWE401_Memory_Leak__new_twoIntsStruct_67
{

typedef struct _structType
{
    twoIntsStruct * structFirst;
} structType;

#ifndef OMITBAD

/* bad function declaration */
void badSink(structType myStruct);

void bad()
{
    twoIntsStruct * data;
    structType myStruct;
    data = NULL;
    /* POTENTIAL FLAW: Allocate memory on the heap */
    data = new twoIntsStruct;
    /* Initialize and make use of data */
    data->intOne = 0;
    data->intTwo = 0;
    printStructLine(data);
    myStruct.structFirst = data;
    badSink(myStruct);
}

#endif /* OMITBAD */

#ifndef OMITGOOD

/* goodG2B uses the GoodSource with the BadSink */
void goodG2BSink(structType myStruct);

static void goodG2B()
{
    twoIntsStruct * data;
    structType myStruct;
    data = NULL;
    /* FIX: Use memory allocated on the stack */
    twoIntsStruct dataGoodBuffer;
    data = &dataGoodBuffer;
    /* Initialize and make use of data */
    data->intOne = 0;
    data->intTwo = 0;
    printStructLine(data);
    myStruct.structFirst = data;
    goodG2BSink(myStruct);
}

/* goodB2G uses the BadSource with the GoodSink */
void goodB2GSink(structType myStruct);

static void goodB2G()
{
    twoIntsStruct * data;
    structType myStruct;
    data = NULL;
    /* POTENTIAL FLAW: Allocate memory on the heap */
    data = new twoIntsStruct;
    /* Initialize and make use of data */
    data->intOne = 0;
    data->intTwo = 0;
    printStructLine(data);
    myStruct.structFirst = data;
    goodB2GSink(myStruct);
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

using namespace CWE401_Memory_Leak__new_twoIntsStruct_67; /* so that we can use good and bad easily */

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
