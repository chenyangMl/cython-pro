import pstats, cProfile

import pyximport
pyximport.install()

import numpy as np
array_1 = np.random.uniform(0, 1000, size=(3000, 2000)).astype(np.intc)
array_2 = np.random.uniform(0, 1000, size=(3000, 2000)).astype(np.intc)
a = 4
b = 3
c = 9

import compute_memview
cProfile.runctx("compute_memview.compute(array_1,array_2,a,b,c)",
                globals(),
                locals={"array_1":array_1,
                        "array_2":array_2,
                        "a":a,"b":b,"c":c},
                        filename="Profile.prof")

s = pstats.Stats("Profile.prof")
s.strip_dirs().sort_stats("time").print_stats()