from distutils.core import setup
from Cython.Build import cythonize

setup(
    name="Rectangle",
    ext_modules = cythonize("CRectangle.pyx", language_level=3),
)

# python setup.py build_ext --inplace