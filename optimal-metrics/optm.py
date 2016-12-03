#!/usr/bin/env python

import sys
import numpy as np
import matplotlib.pyplot as plt

# problem definition in the context of video streaming rate adaptation:
# at each step in time, the throuhput (th) changes following the poisson distribution
# for a short period.
# there are a list of bitrates (r) and bitrate can be switched at each time step or remain the same.
# what is the maximum bitrate that can be achieved for any particular number of change and what is the
# buffer occupancy associated with it.
# note that a path cannot be considered if it leads to underflow. 

if len(sys.argv) < 2:
    print("usage: %s <result file> " % sys.argv[0])
    sys.exit() 

f = open(sys.argv[1], 'w')
f.write('change bitrate buffer\n')

period = 30
r_lst = [1500, 2000, 3000]
th_max_lst = [1700, 1900, 2200, 2500, 2800, 3200]
th_lst = np.array([], dtype=int)

# generate a list of throughputs with in periods of 30 each having a 
# poisson distribution with a lambda in th_max_lst

for th_max in th_max_lst:
    th_lst = np.concatenate((th_lst, np.random.poisson(th_max, period)))

steps = period * len(th_max_lst)

# uncomment this part to see the throughput distribution
#count, bins, ignored = plt.hist(th_lst)
#plt.show()

res_past = {}
res_curr = {}

for r in r_lst:
    res_past[r] = {0:{'r':r, 'buf':th_lst[0]/float(r)}} 

# Each step the throughput changes and the bitrate can change or remain the same.
# Using dynamic programming, this calculate all path which do not cause underflow
# and keep the buffer occupancy and accumulated bitrate.

for i in range(1, steps):
    for r_curr in r_lst:
        for r_past in r_lst:
            for p in res_past[r_past].keys():
                if res_past[r_past][p]['buf'] + th_lst[i]/float(r_curr) - 1 > 0:
                   c = 0 if r_past == r_curr else 1
                   if r_curr not in res_curr.keys():
                       res_curr[r_curr] = {}
                   if (p+c not in res_curr[r_curr].keys()) or (res_past[r_past][p]['r'] + r_curr > res_curr[r_curr][p+c]['r']):
                       res_curr[r_curr][p+c] = {}
                       res_curr[r_curr][p+c]['r'] = res_past[r_past][p]['r'] + r_curr
                       res_curr[r_curr][p+c]['buf'] = res_past[r_past][p]['buf'] + th_lst[i]/float(r_curr) - 1
    res_past = res_curr
    res_curr = {}


hist = {}

# calculate final results and save them in file with the columns associated with
# change, bitrate, and buffer occupancy

for i in range(steps):
    maxr = 0
    entry = {}
    for p in res_past.keys():
        if (i in res_past[p]) and (res_past[p][i]['r'] > maxr):
            maxr = res_past[p][i]['r']
            entry = res_past[p][i]
    if entry:        
        hist[i] = entry
        hist[i]['r'] = hist[i]['r']/steps
        line = str(i) + ' ' + str(hist[i]['r']) + ' ' + str(hist[i]['buf']) + '\n'
        f.write(line)

print(hist)

f.close()                 
