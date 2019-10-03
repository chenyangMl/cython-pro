"""
prime(质数):  - 大于1的自然数 and 只能被1和自身整除的数
"""
def primes(int nb_primes):
    cdef int n,i,len_p
    cdef int p[1000]
    if nb_primes > 1000:
        nb_primes = 1000
    len_p = 0
    n = 2
    while len_p < nb_primes:
        #Is n prime?
        for i in p[:len_p]:
            if n % i == 0:
                break
        else:
            p[len_p] = n
            len_p += 1
        n +=1
    #保存c类型数组到python list
    res_list = [prime for prime in p[:len_p]]
    return res_list