
# coding: utf-8

# In[1]:


import matplotlib.pyplot as plt
import sgbm
import stdev
import simple_return as sr
import duration
import numpy as np
import pandas as pd
import statistics as sc
from scipy.stats import kurtosis, skew
import pickle
import os
import multiprocessing
from multiprocessing import Pool


# In[2]:


x=pd.ExcelFile('/home/anindya/Parallel_code/Squeeze/Stat.xlsx')
page=x.parse(0)
N=page.N
mu=page.tdrift
tvola=page.tvola
p=0.15


# In[3]:


with open('/home/anindya/Parallel_code/Squeeze/vol.pkl','rb') as f:
    vol = pickle.load(f)


# In[4]:


seed=range(0,201)
dt=5./(250*360)
sdt=np.sqrt(dt)
name="/home/anindya/Parallel_code/Squeeze/SMGBM/Group1/"


# In[5]:


def loop(k,theta,r,b):
    GM_m=[]
    GS_m=[]
    GW_m=[]
    GK_m=[]
    l=[]
    if(tvola[k]-((p*(np.percentile(vol[k],r))))>0):
        si1=np.percentile(vol[k],r)
    else:
        si1=tvola[k]/p
    si2=((tvola[k]-(p*si1))/(1-p))
    for j in range(200):
        sm=sgbm.sgbm(dt,N[k],p*100,mu[k],si1,si2,theta,b,seed[j])
        ret_m=sr.s_ret(np.array(sm,dtype=float))
        ret_m=np.array(ret_m)
        L=len(ret_m)
        n=20
        new_ret_m=[np.array(ret_m[i:i+n]) for i in range(L-n)]
        Ln=len(new_ret_m)
        new_std_m=np.array([stdev.sd(new_ret_m[i]) for i in range(Ln)])
        volatility_m= new_std_m/sdt
        dur_m=duration.duration(np.array(volatility_m))
        dur_m=np.array(dur_m,dtype=float)
        GM_m.append(np.mean(dur_m))
        GS_m.append(stdev.sd(dur_m))
        GW_m.append(skew(dur_m))
        GK_m.append(kurtosis(dur_m,fisher=False))
        l.append(len(dur_m))
    return (GM_m,GS_m,GW_m,GK_m,l)
#     return (GM_m,GS_m)


# In[6]:


pool = Pool()

for k in range(0,6,1):
    name1=name+"I0"+str(k+1)
    if not os.path.exists(name1):
        os.mkdir(name1)
    for b in range(2,15,1):
        name2=name1+"/shape"+str(b)
        if not os.path.exists(name2):
            os.mkdir(name2)
        for i in range(5,17,1):
            t1=[]
            t2=[]
            t3=[]
            t4=[]
            L1=[]
            theta=i
            args=[]
            for r in range(0,31,1):
                args.append((k,theta,r,b))
            for one,two,three,four,ll in pool.starmap(loop, args):
                t1.append(one)
                t2.append(two)
                t3.append(three)
                t4.append(four)
                L1.append(ll)
            strname=name2+"/theta"+str(i)+".xlsx"
            writer=pd.ExcelWriter(strname,engine='xlsxwriter')
            for w in range(0,31,1):
                df=pd.DataFrame({'T1':t1[w],'T2':t2[w],'T3':t3[w],'T4':t4[w],'Len':L1[w]},index=range(1,201))
                vv="Vola"+str((w))
                df.to_excel(writer,sheet_name=vv)
            writer.save()
            
pool.close()
