#touch compute_typed.pyx
import numpy as np

DTYPE = np.intc

# cdef means here that this function is a plain C function (so faster).
# To get all the benefits, we type the arguments and the return value.
cdef int clip(int a, int min_value, int max_value):
    return min(max(a, min_value), max_value)

def compute(array_1, array_2, int a, int b, int c):

    cdef int x_max = array_1.shape[0]
    cdef int y_max = array_1.shape[1]

    assert array_1.shape == array_2.shape
    assert array_1.dtype == DTYPE
    assert array_2.dtype == DTYPE

    result = np.zeros((x_max, y_max), dtype=DTYPE)

    cdef int tmp

    # Py_ssize_t is the proper C type for Python array indices.
    cdef int x, y

    for x in range(x_max):
        for y in range(y_max):

            tmp = clip(array_1[x, y], 2, 10)
            tmp = tmp * a + array_2[x, y] * b
            result[x, y] = tmp + c

    return result