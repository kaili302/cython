This user guide is same as [Cython official tutorial](http://docs.cython.org/en/latest/src/userguide/wrapping_CPlusPlus.html).

# Overview
Cython has native support for most of the C++ language. Specifically:
- C++ objects can be dynamically allocated with new and del keywords.
- C++ objects can be stack-allocated.
- C++ classes can be declared with the new keyword cppclass.
- Templated classes and functions are supported.
- Overloaded functions are supported.
- Overloading of C++ operators (such as operator+, operator[],…) is supported

# Procedure Overview¶
The general procedure for wrapping a C++ file can now be described as follows:

- Specify C++ language in a setup.py script or locally in a source file.
- Create one or more .pxd files with cdef extern from blocks and (if existing) the C++ namespace name. In these blocks:
 - declare classes as cdef cppclass blocks
 - declare public names (variables, methods and constructors)
- cimport them in one or more extension modules (.pyx files).