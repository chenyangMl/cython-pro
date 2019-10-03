from distutils.core import setup
from Cython.Build import cythonize

setup (
    ext_modules = cythonize(["example.pyx",
                             "example_py_cy.py"],
                             annotate=True)
)