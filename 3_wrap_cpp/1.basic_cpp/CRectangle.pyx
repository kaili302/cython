# distutils: language = c++

# This will create a cpp file called `CRectangle.cpp`. So be very carefull not introducing
# name clashing with original C++ file, for example using 'Rectangle.pyx'

from Rectangle cimport Rectangle

# Use C++ class
def main():
    rec_ptr = new Rectangle(1, 2, 3, 4)  # Instantiate a Rectangle object on the heap

    # IMPORTANT: Instantiate a Rectangle object on the stack, default constructor is required
    cdef Rectangle rec_stack
   
    try:
        rec_area = rec_ptr.getArea()
    finally:
        del rec_ptr  # delete heap allocated object

    return Rectangle(1, 2, 3, 4).getArea()


# Now, we need to make the C++ class accessible from external Python code (which is our whole point).
# We need to create Cython Wrapper class. Yeppp,,,,,
# Common programming practice is to create a Cython extension type which holds a C++ instance
# as an attribute and create a bunch of forwarding methods. So we can implement the Python
# extension type as:

cdef class PyRectangle:
    # If your extension type instantiates a wrapped C++ class using the default
    # constructor, you may be able to simplify the lifecycle handling by
    # tying it directly to the lifetime of the Python wrapper object. Instead of
    # a pointer attribute, you can declare an instance:
    # Cython will automatically generate code that instantiates the C++ object 
    # instance when the Python object is created and deletes it when the Python object
    # is garbage collected.
    cdef Rectangle c_rect  # Hold a C++ instance which we're wrapping

    # [cinit vs init](https://cython.readthedocs.io/en/latest/src/userguide/special_methods.html#initialisation-methods-cinit-and-init)
    def __cinit__(self, int x0, int y0, int x1, int y1):
        self.c_rect = Rectangle(x0, y0, x1, y1)

    def get_area(self):
        return self.c_rect.getArea()

    def get_size(self):
        cdef int width, height
        self.c_rect.getSize(&width, &height)
        return width, height

# Cython initializes C++ class attributes of a cdef class using the nullary constructor. 
# If the class you’re wrapping does not have a nullary constructor, you must store a pointer
# to the wrapped class and manually allocate and deallocate it. Alternatively, the cpp_locals
# directive avoids the need for the pointer and only initializes the C++ class attribute when
# it is assigned to. A convenient and safe place to do so is in the __cinit__ and __dealloc__
# methods which are guaranteed to be called exactly once upon creation and deletion of the Python instance.
# distutils: language = c++

cdef class PyRectangle2:
    cdef Rectangle* c_rect  # hold a pointer to the C++ instance which we're wrapping

    def __cinit__(self, int x0, int y0, int x1, int y1):
        self.c_rect = new Rectangle(x0, y0, x1, y1)

    def __dealloc__(self):
        del self.c_rect

    def get_area(self):
        # Note that if one has pointers to C++ objects, dereferencing is optional.
        # But must be done to avoid doing pointer arithmetic rather than
        # arithmetic on the objects themselves
        return self.c_rect[0].getArea()

    def get_size(self):
        cdef int width, height
        self.c_rect.getSize(&width, &height)
        return width, height