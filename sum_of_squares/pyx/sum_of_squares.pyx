# distutils: language=c++
# double asterisk (**) is defined as exponentiation operator

cdef long square(int a):   # can't be imported to python
   return a**2

def sum_of_squares(): # can't be imported to python
    cdef long s = 0
    cdef int i = 0

    for i in range(1, 10**6 + 1):
        s += square(i)
    return s

cpdef long sum_of_squares2(): # can be imported to python
    cdef long s = 0
    cdef int i = 0

    for i in range(1, 10**6 + 1):
        s += square(i)
    return s