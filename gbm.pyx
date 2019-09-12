#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 12 11:55:17 2017

@author: milan
"""
import numpy as np
from libc.math cimport exp,sqrt
#####################################################################################
# generate gbm
cpdef gbm(float dt,long int N, float mu, float si, int k):
    np.random.seed(k)
    cdef double a=0.0
    sdt=sqrt(dt)
    St=[1.]        
    for i in range(N-1):
        w=np.random.normal(0,sdt)
        a=a+mu*dt +si*w -0.5*(si**2)*dt
        St.append(exp(a))
    return(St)
#################################################################################################### 
