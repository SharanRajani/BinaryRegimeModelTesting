#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan  2 13:47:52 2018

@author: milan
"""
cdef extern from "math.h":
    double sqrt(double m)

from numpy cimport ndarray
cimport numpy as np
cimport cython

@cython.boundscheck(False)
def sd(ndarray[np.float64_t, ndim=1] a not None):
    cdef Py_ssize_t i
    cdef Py_ssize_t n = a.shape[0]
    cdef double m = 0.0
    for i in range(n):
        m += a[i]
    m /= n
    cdef double v = 0.0
    for i in range(n):
        v += (a[i] - m)**2
    return sqrt(v / (n-1)) 