### Profile tutorial--性能分析

参考: <http://docs.cython.org/en/latest/src/tutorial/profiling_tutorial.html>

性能分析:指通过性能测试报告对所写代码进行整体和局部(函数)的运行效率分析，为后续的性能优化提供决策支持。

#### 1. 纯python的性能分析

分析案例:

- 1)自己写的python代码文件calc_pi.py

  ```python
  # calc_pi.py
  
  def recip_square(i):
      return 1. / i ** 2
  
  def approx_pi(n=10000000):
      val = 0.
      for k in range(1, n + 1):
          val += recip_square(k)
      return (6 * val) ** .5
  ```

  

- 2) 编写性能分析脚本python_profile.py

  ```python
  # python_profile.py
  
  import pstats, cProfile
  
  import calc_pi
  
  cProfile.runctx("calc_pi.approx_pi()", globals(), locals(), "Profile.prof")
  
  s = pstats.Stats("Profile.prof")
  s.strip_dirs().sort_stats("time").print_stats()
  ```

  运行性能分析脚步，结果如下:

  ```
           10000004 function calls in 3.361 seconds
  
     Ordered by: internal time
  
     ncalls  tottime  percall  cumtime  percall filename:lineno(function)
   10000000    2.439    0.000    2.439    0.000 calc_pi.py:3(recip_square)
          1    0.922    0.922    3.361    3.361 calc_pi.py:6(approx_pi)
          1    0.000    0.000    3.361    3.361 {built-in method builtins.exec}
          1    0.000    0.000    3.361    3.361 <string>:1(<module>)
          1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}
  ```

#### 2. Cython的性能分析

- 1、自己的Cython代码,calc_pi.pyx文件

  ```cython
  # cython: profile=True
  
  # calc_pi.pyx
  
  def recip_square(int i):
      return 1. / i ** 2
  
  def approx_pi(int n=10000000):
      cdef double val = 0.
      cdef int k
      for k in range(1, n + 1):
          val += recip_square(k)
      return (6 * val) ** .5
  ```

  **注意** 上述第一行`# cython: profile=True`是显示告诉Cython启用分析，必须加上。

- 2、性能分析脚步cython_profile.py

  ```python
  # cython_profile.py
  
  import pstats, cProfile
  
  import pyximport
  pyximport.install()
  
  import calc_pi
  
  cProfile.runctx("calc_pi.approx_pi()", globals(), locals(), "Profile.prof")
  
  s = pstats.Stats("Profile.prof")
  s.strip_dirs().sort_stats("time").print_stats()
  ```

  运行性能分析脚步,结果如下:

  ```
           10000004 function calls in 3.146 seconds
  
     Ordered by: internal time
  
     ncalls  tottime  percall  cumtime  percall filename:lineno(function)
   10000000    2.233    0.000    2.233    0.000 calc_pi.py:2(recip_square)
          1    0.914    0.914    3.146    3.146 calc_pi.py:5(approx_pi)
          1    0.000    0.000    3.146    3.146 {built-in methodcy builtins.exec}
          1    0.000    0.000    3.146    3.146 <string>:1(<module>)
          1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}
  ```

- 3 基于性能分析内容进行代码优化。

- 4 关闭对某个函数的性能分析，只需要在函数加一个`@cython.profile(False)`的装饰器即可，如停止对函数**recip_square**的性能分析:

  ```cython
  cimport cython
  @cython.profile(False)
  def recip_square(int i):
      return 1. / i ** 2
  ```

  