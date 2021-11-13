This user guide is same as [Cython official tutorial](http://docs.cython.org/en/latest/src/userguide/external_C_code.html).

# External declarations

use `extern` to specify cdef func and var are defined elsewhere, for example:
```cython
# But cython only make a declaration in generated c file, without knowing where they are defined
cdef extern int spam_counter
cdef extern void order_spam(int tons)

# correct
cdef extern from "spam.h":
    int spam_counter
    void order_spam(int tons)
```

The `cdef extern from` clause does three things:
- It directs Cython to place a #include statement for the named header file in the generated C code.
- It prevents Cython from generating any C code for the declarations found in the associated block.
- It treats all declarations within the block as though they started with cdef extern.