def hello():
    print("Hello, World!")


cdef class HelloWorld:
    cdef char* a
    cdef char* b

    def __cinit__(self, char* a, char* b):
        self.a = a
        self.b = b
    
    def sum(self):
        return self.a + self.b

cpdef char* hello_word():
    cdef char* h = "hello"
    cdef char* w = "world"
    cdef HelloWorld hw = HelloWorld(h, w)
    return hw.sum()