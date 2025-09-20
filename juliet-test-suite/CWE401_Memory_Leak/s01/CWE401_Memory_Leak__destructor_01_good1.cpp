/*
 * @description Memory Leak
 * 
 * */

#include "std_testcase.h"

namespace CWE401_Memory_Leak__destructor_01
{

#ifndef OMITGOOD

class GoodClass 
{
    public:
        GoodClass(const char * name)
        {        
            if (name)
            {
                this->name = new char[strlen(name) + 1];
                strcpy(this->name, name);
            }
            else
            {
                this->name = new char[1];
                *(this->name) = '\0';
            }
        }

        ~GoodClass()
        {
            /* FIX: Deallocate memory in the destructor that was allocated in the constructor */
            delete [] name;
        }

        /* copy constructor is only here to avoid double free incidentals */
        GoodClass(GoodClass &goodClassObject)
        { 
            this->name = new char[strlen(goodClassObject.name) + 1];
            strcpy(this->name, goodClassObject.name);
        }

        /* operator= is only here to avoid double free incidentals */
        GoodClass& operator=(const GoodClass &goodClassObject) 
        { 
            if (&goodClassObject != this) 
            { 
                this->name = new char[strlen(goodClassObject.name) + 1];
                strcpy(this->name, goodClassObject.name);
            } 
            return *this; 
        }

        void printName()
        {
            printLine(name);
        }

    private:
        char * name;
    };

static void good1()
{
    GoodClass goodClassObject ("GoodClass");

    goodClassObject.printName();
}

void good()
{
    good1();
}

#endif /* OMITGOOD */

} /* close namespace */

/* Below is the main(). It is only used when building this testcase on 
 * its own for testing or for building a binary to use in testing binary 
 * analysis tools. It is not used when compiling all the testcases as one 
 * application, which is how source code analysis tools are tested. 
 */ 

#ifdef INCLUDEMAIN

using namespace CWE401_Memory_Leak__destructor_01; /* so that we can use good and bad easily */

int main(int argc, char * argv[])
{
    /* seed randomness */
    srand( (unsigned)time(NULL) );
#ifndef OMITGOOD
    printLine("Calling good()...");
    good();
    printLine("Finished good()");
#endif /* OMITGOOD */
    return 0;
}

#endif
