This user guide is same as [Cython official tutorial](http://docs.cython.org/en/latest/src/userguide/language_basics.html).

# Python functions vs. C functions
There are two kinds of function definition in Cython:

Python functions are defined using the def statement, as in Python. They take Python objects as parameters and return Python objects.

C functions are defined using the cdef statement in Cython syntax or with the @cfunc decorator. They take either Python objects or C values as parameters, and can return either Python objects or C values.