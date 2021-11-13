from distutils.core import setup
from Cython.Build import cythonize

setup(
    name="SumOfSquares",
    ext_modules = cythonize("sum_of_squares.pyx", language_level=3),
)