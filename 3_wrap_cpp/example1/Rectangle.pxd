cdef extern from "cpp/Rectangle.cpp":
    # include the C++ code from Rectangle.cpp. It is also possible to specify to setuptools
    # that Rectangle.cpp is a source. To do that, you can add this directive
    # at the top of the .pyx (not .pxd) file: # distutils: sources = Rectangle.cpp
    pass


# Declare the class with cdef. Note that the constructor is declared as “except +”. 
# If the C++ code or the initial memory allocation raises an exception due to a failure,
# this will let Cython safely raise an appropriate Python exception instead (see below).
# Without this declaration, C++ exceptions originating from the constructor will not be
# handled by Cython.
cdef extern from "cpp/Rectangle.h" namespace "shapes":
    cdef cppclass Rectangle:
        # no need to list all functions, only what is needed.
        Rectangle() except +
        Rectangle(int, int, int, int) except +
        int x0, y0, x1, y1
        int getArea()
        void getSize(int* width, int* height)
        void move(int, int)