/* TEMPLATE GENERATED TESTCASE FILE
Filename: CWE401_Memory_Leak__new_array_struct_twoIntsStruct_72a.cpp
Label Definition File: CWE401_Memory_Leak__new_array.label.xml
Template File: sources-sinks-72a.tmpl.cpp
*/
/*
 * @description
 * CWE: 401 Memory Leak
 * BadSource:  Allocate data using new[]
 * GoodSource: Point data to a stack buffer
 * Sinks:
 *    GoodSink: call delete[] on data
 *    BadSink : no deallocation of data
 * Flow Variant: 72 Data flow: data passed in a vector from one function to another in different source files
 *
 * */

#include "std_testcase.h"
#include <vector>

#ifndef _WIN32
#include <wchar.h>
#endif

using namespace std;

namespace CWE401_Memory_Leak__new_array_struct_twoIntsStruct_72
{

#ifndef OMITBAD

/* bad function declaration */
void badSink(vector<struct _twoIntsStruct *> dataVector);

void bad()
{
    struct _twoIntsStruct * data;
    vector<struct _twoIntsStruct *> dataVector;
    data = NULL;
    /* POTENTIAL FLAW: Allocate memory on the heap */
    data = new struct _twoIntsStruct[100];
    /* Initialize and make use of data */
    data[0].intOne = 0;
    data[0].intTwo = 0;
    printStructLine((twoIntsStruct *)&data[0]);
    /* Put data in a vector */
    dataVector.insert(dataVector.end(), 1, data);
    dataVector.insert(dataVector.end(), 1, data);
    dataVector.insert(dataVector.end(), 1, data);
    badSink(dataVector);
}

#endif /* OMITBAD */

#ifndef OMITGOOD

/* goodG2B uses the GoodSource with the BadSink */
void goodG2BSink(vector<struct _twoIntsStruct *> dataVector);

static void goodG2B()
{
    struct _twoIntsStruct * data;
    vector<struct _twoIntsStruct *> dataVector;
    data = NULL;
    /* FIX: Use memory allocated on the stack */
    struct _twoIntsStruct dataGoodBuffer[100];
    data = dataGoodBuffer;
    /* Initialize and make use of data */
    data[0].intOne = 0;
    data[0].intTwo = 0;
    printStructLine((twoIntsStruct *)&data[0]);
    /* Put data in a vector */
    dataVector.insert(dataVector.end(), 1, data);
    dataVector.insert(dataVector.end(), 1, data);
    dataVector.insert(dataVector.end(), 1, data);
    goodG2BSink(dataVector);
}

/* goodB2G uses the BadSource with the GoodSink */
void goodB2GSink(vector<struct _twoIntsStruct *> dataVector);

static void goodB2G()
{
    struct _twoIntsStruct * data;
    vector<struct _twoIntsStruct *> dataVector;
    data = NULL;
    /* POTENTIAL FLAW: Allocate memory on the heap */
    data = new struct _twoIntsStruct[100];
    /* Initialize and make use of data */
    data[0].intOne = 0;
    data[0].intTwo = 0;
    printStructLine((twoIntsStruct *)&data[0]);
    dataVector.insert(dataVector.end(), 1, data);
    dataVector.insert(dataVector.end(), 1, data);
    dataVector.insert(dataVector.end(), 1, data);
    goodB2GSink(dataVector);
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

using namespace CWE401_Memory_Leak__new_array_struct_twoIntsStruct_72; /* so that we can use good and bad easily */

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
