[check directly](https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html)
# Advanced C++ features


# Overloading
```cython
cdef extern from "Foo.h":
    cdef cppclass Foo:
        Foo(int)
        Foo(bool)
        Foo(int, bool)
        Foo(int, int)
```

# Cython uses C++ naming for overloading operators:
```
cdef extern from "foo.h":
    cdef cppclass Foo:
        Foo()
        Foo operator+(Foo)
        Foo operator-(Foo)
        int operator*(Foo)
        int operator/(int)
        int operator*(int, Foo) # allows 1*Foo()
    # nonmember operators can also be specified outside the class
    double operator/(double, Foo)


# This is only valid in pyx
cdef Foo foo

foo2 = foo + foo
foo2 = foo - foo

x = foo * foo2
x = foo / 1

# Note that if one has pointers to C++ objects, dereferencing must be done to avoid doing 
# pointer arithmetic rather than arithmetic on the objects themselves
cdef Foo* foo_ptr = new Foo()
foo = foo_ptr[0] + foo_ptr[0]
x = foo_ptr[0] / 2

del foo_ptr
```


# [Templates](https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html#templates)
Cython uses a bracket syntax for templating. A simple example for wrapping C++ vector:

## Templates class
```
cdef extern from "<vector>" namespace "std":
    cdef cppclass vector[T]:
        ...
```
**Multiple template parameters can be defined as a list, such as [T, U, V] or [int, bool, char]**
## Templates functions
```
# distutils: language = c++
cdef extern from "<algorithm>" namespace "std":
    T max[T](T a, T b)

print(max[long](3, 4))
print(max(1.5, 2.5))  # simple template argument deduction
```

# Nested class declaration
C++ allows nested class declaration. Class declarations can also be nested in Cython:
```
# distutils: language = c++

cdef extern from "<vector>" namespace "std":
    cdef cppclass vector[T]:
        cppclass iterator:
            T operator*()
            iterator operator++()
            bint operator==(iterator)
            bint operator!=(iterator)
        vector()
        void push_back(T&) # reference type
        T& operator[](int)
        T& at(int)
        iterator begin()
        iterator end()

cdef vector[int].iterator iter  #iter is declared as being of type vector<int>::iterator
```

# C++ operators not compatible with Python syntax
*Cython tries to keep its syntax as close as possible to standard Python.* Because of this, certain C++ operators, like the preincrement ++foo or the dereferencing operator *foo cannot be used with the same syntax as C++. Cython provides functions replacing these operators in a special module cython.operator:

- `cython.operator.dereference` for dereferencing. `dereference(foo)` will produce the C++ code `*(foo)`
- `cython.operator.preincrement` for pre-incrementation. `preincrement(foo)` will produce the C++ code `++(foo)`. Similarly for `predecrement`, `postincrement` and `postdecrement`.
- `cython.operator.comma` for the comma operator. `comma(a, b)` will produce the C++ code `((a), (b))`.
  
```cython
from cython.operator cimport dereference as deref, preincrement as inc

cdef vector[int] *v = new vector[int]()
cdef int i
for i in range(10):
    v.push_back(i)

cdef vector[int].iterator it = v.begin()
while it != v.end():
    print(deref(it))
    inc(it)

del v
```

# Standard library
Most of the containers of the C++ Standard Library have been declared in pxd files located in /Cython/Includes/libcpp. These containers are: deque, list, map, pair, queue, set, stack, vector.
``` 
# pyx
# distutils: language = c++

from libcpp.vector cimport vector

cdef vector[int] vect
cdef int i, x

for i in range(10):
    vect.push_back(i)

for i in range(10):
    print(vect[i])

for x in vect:
    print(x)
```
The pxd files in [/Cython/Includes/libcpp](https://github.com/cython/cython/tree/master/Cython/Includes/libcpp) also work as good examples on how to declare C++ classes.

The STL containers coerce from and to the corresponding Python builtin types. The conversion is triggered either by an assignment to a typed variable (including typed function arguments) or by an explicit cast, e.g.:
```
# distutils: language = c++

from libcpp.string cimport string
from libcpp.vector cimport vector

py_bytes_object = b'The knights who say ni'
py_unicode_object = u'Those who hear them seldom live to tell the tale.'

cdef string s = py_bytes_object
print(s)  # b'The knights who say ni'

cdef string cpp_string = <string> py_unicode_object.encode('utf-8')
print(cpp_string)  # b'Those who hear them seldom live to tell the tale.'

cdef vector[int] vect = range(1, 10, 2)
print(vect)  # [1, 3, 5, 7, 9]

cdef vector[string] cpp_strings = b'It is a good shrubbery'.split()
print(cpp_strings[1])   # b'is'

# For loops
def main():
    cdef vector[int] v = [4, 6, 5, 10, 3]

    cdef int value
    for value in v:
        print(value)

    return [x*x for x in v if x % 2 == 0]
```

# Exceptions
Cython cannot throw C++ exceptions, or catch them with a try-except statement, but it is possible to declare a function as potentially raising an C++ exception and converting it into a Python exception. For example,

```
cdef extern from "some_file.h":
    cdef int foo() except +
```
This will translate try and the C++ error into an appropriate Python exception. The translation is performed according to the following table (the std:: prefix is omitted from the C++ identifiers):
https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html
