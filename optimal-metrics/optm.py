#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

period = 30
r_lst = [1500, 2000, 3000]
th_max_lst = [1700, 1900, 2200, 2500, 2800, 3200]
th_lst = np.array([], dtype=int)

# generate a list of throughputs with in periods of 30 each having a 
# poisson distribution with a lambda in th_max_lst
for th_max in th_max_lst:
    th_lst = np.concatenate((th_lst, np.random.poisson(th_max, period)))

steps = period * len(th_max_lst)

#print(th_lst)
#count, bins, ignored = plt.hist(th_lst)
#plt.show()

res_past = {}
res_curr = {}

for r in r_lst:
    res_past[r] = {0:{'r':r, 'buf':th_lst[0]/float(r)}} 

print(res_past)

for i in range(1, steps):
    for r_curr in r_lst:
        for r_past in r_lst:
            for p in res_past[r_past].keys():
                if res_past[r_past][p]['buf'] + th_lst[i]/float(r_curr) > 0:
                   c = 0 if r_past == r_curr else 1
                   if r_curr not in res_curr.keys():
                       res_curr[r_curr] = {}
                   if (p+c not in res_curr[r_curr].keys()) or (res_past[r_past][p]['r'] + r_curr > res_curr[r_curr][p+c]['r']):
                       res_curr[r_curr][p+c] = {}
                       res_curr[r_curr][p+c]['r'] = res_past[r_past][p]['r'] + r_curr
                       res_curr[r_curr][p+c]['buf'] = res_past[r_past][p]['buf'] + th_lst[i]/float(r_curr)
    res_past = res_curr
    res_curr = {}


print(res_past)
                     
