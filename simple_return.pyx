#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan  2 15:31:38 2018

@author: milan
"""

cdef extern from "math.h":
    double sqrt(double m)

from numpy cimport ndarray
cimport numpy as np
cimport cython

@cython.boundscheck(False)
def s_ret(ndarray[np.float64_t, ndim=1] a not None):
    cdef Py_ssize_t i
    cdef Py_ssize_t n = a.shape[0]
    ret= [0]*(n-1)
    for i in range(n-1):
        ret[i]= (a[i+1]-a[i])/a[i]
    return ret 