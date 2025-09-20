/* TEMPLATE GENERATED TESTCASE FILE
Filename: CWE401_Memory_Leak__new_TwoIntsClass_54d.cpp
Label Definition File: CWE401_Memory_Leak__new.label.xml
Template File: sources-sinks-54d.tmpl.cpp
*/
/*
 * @description
 * CWE: 401 Memory Leak
 * BadSource:  Allocate data using new
 * GoodSource: Allocate data on the stack
 * Sinks:
 *    GoodSink: call delete on data
 *    BadSink : no deallocation of data
 * Flow Variant: 54 Data flow: data passed as an argument from one function through three others to a fifth; all five functions are in different source files
 *
 * */

#include "std_testcase.h"

#ifndef _WIN32
#include <wchar.h>
#endif

namespace CWE401_Memory_Leak__new_TwoIntsClass_54
{

#ifndef OMITBAD

/* bad function declaration */
void badSink_e(TwoIntsClass * data);

void badSink_d(TwoIntsClass * data)
{
    badSink_e(data);
}

#endif /* OMITBAD */

#ifndef OMITGOOD

/* goodG2B uses the GoodSource with the BadSink */
void goodG2BSink_e(TwoIntsClass * data);

void goodG2BSink_d(TwoIntsClass * data)
{
    goodG2BSink_e(data);
}

/* goodB2G uses the BadSource with the GoodSink */
void goodB2GSink_e(TwoIntsClass * data);

void goodB2GSink_d(TwoIntsClass * data)
{
    goodB2GSink_e(data);
}

#endif /* OMITGOOD */

} /* close namespace */
