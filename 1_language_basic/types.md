This user guide is same as [Cython official tutorial](http://docs.cython.org/en/latest/src/userguide/language_basics.html).

# C variable and type definitions
## basic
```cython
cdef int a_global_variable

def func():
    cdef int i, j, k
    cdef float f, g[42], *h

# Moreover, C struct, union and enum are supported
cdef struct Grail:
    int age
    float volume

cdef union Food:
    char *spam
    float *eggs

cdef enum CheeseType:
    cheddar, edam,
    camembert

cdef enum CheeseState:
    hard = 1
    soft = 2
    runny = 3

# Declaring an enum as cpdef will create a PEP 435-style Python wrapper:
cpdef enum CheeseState:
    hard = 1
    soft = 2
    runny = 3

# type alias
ctypedef unsigned long ULong

ctypedef int* IntPtr

# use Cython extension type, i.e `cdef class`
from __future__ import print_function

cdef class Shrubbery:
    cdef int width
    cdef int height

    def __init__(self, w, h):
        self.width = w
        self.height = h

    def describe(self):
        print("This shrubbery is", self.width,
              "by", self.height, "cubits.")
```

## Types
The Cython language uses the normal C syntax for C types, including pointers. It provides all the standard C types, namely `char`, `short`, `int`, `long`, `long long` as well as their `unsigned` versions, e.g. unsigned int (cython.uint in Python code). The special bint type is used for C boolean values (int with 0/non-0 values for False/True) and Py_ssize_t for (signed) sizes of Python containers.

```cython
# list
cdef list foo = []

# tuple
cdef (double, int) bar

# Grouping multiple C declarations
# If you have a series of declarations that all begin with cdef, you can group them into a cdef block like this:
from __future__ import print_function

cdef:
    struct Spam:
        int tons

    int i
    float a
    Spam *p

    void f(Spam *s) except *:
        print(s.tons, "Tons of spam")
```