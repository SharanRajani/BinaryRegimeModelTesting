#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 19 11:06:29 2017

@author: milan
"""

import numpy as np
from libc.math cimport exp,sqrt
#####################################################################################
# generate mgbm
cpdef sgbm(float dt, long int N, int p, float mu, float si1, float si2,float th1,float b,int se):
    np.random.seed(se)
    cdef float p_1=(100/p)-1, th2, s, a
    cdef double sdt=sqrt(dt), w,yy
    cdef int ij ,i ,j, old_s, new_s 
    th2=th1*p_1;b2=b*p_1
    th=[th1,th2]
    sigma=[si1,si2]
    ab=[b,b]
    
    ij=0   
    s=0
    sg=[]
    while(s<=N):
        yy=np.random.gamma(ab[ij],th[ij])
        old_s=int(s)
        s=s+yy
        new_s=int(s)
        sg.append(sigma[ij]*np.ones(new_s-old_s))
        ij=1-ij
        #S.append(np.floor(s))

    sg1=[]
    for i in range(len(sg)):
        for j in range(len(sg[i])):
            sg1.append(sg[i][j])
    if len(sg1) < N:
        if sg1[len(sg1)-1]==sigma[1]:
            nsg=[sigma[0]]*(N-len(sg1))
            sg1=np.concatenate((sg1,nsg),axis=0)
        else:
            nsg1=[sigma[1]]*(N-len(sg1))
            sg1=np.concatenate((sg1,nsg1),axis=0)
            
    a=0.
    St=[1.]        
    for i in range(N-1):
        w=np.random.normal(0,sdt)
        a=a+mu*dt +sg1[i]*w -0.5*(sg1[i]**2)*dt
        St.append(np.exp(a))
    return(St)
#################################################################################################### 
