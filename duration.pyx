#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan  3 23:10:54 2018

@author: milan
"""

from numpy cimport ndarray
import numpy as np
cimport numpy as np
cimport cython
@cython.boundscheck(False)
cpdef duration(ndarray[np.float64_t, ndim=1] a ):
    cdef Py_ssize_t n = a.shape[0]
    cdef float p
    cdef int flag, j
    p=np.percentile(a,15)
    flag=1
    transition=[]
    for j in range(n):
        if flag*a[j]< flag*p:
            transition.append(j)
            flag=-flag
    dur=np.diff(transition)[::2]
    # print("Squeeze")
    return(dur)