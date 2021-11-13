from distutils.core import setup
from Cython.Build import cythonize

setup(
    name="Hello",
    ext_modules = cythonize("hello.pyx", language_level=3, language="c++"),
)