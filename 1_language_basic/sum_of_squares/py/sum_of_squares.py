def square(a):
   return a**2

def sum_of_squares():
    s = 0
    for i in range(1, 10**6 + 1):
        s += square(i)
    return s

if __name__ == "__main__":
    print(sum_of_squares())

# python -m timeit "from sum_of_squares import sum_of_squares; sum_of_squares()"
# 10 loops, best of 3: 189 msec per loop
# python -m cProfile sum_of_squares.py