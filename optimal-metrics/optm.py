#!/usr/bin/env python

import sys
import numpy as np
import matplotlib.pyplot as plt

# Problem definition in the context of video streaming rate adaptation

# At each step in time, the throuhput (th) changes following the poisson distribution for a short period. 
# For each time window therefore, there will be a different arrival rate.

# There are a list of bitrates (r) and bitrate can be switched at each time step or remain the same.

# What is the maximum bitrate that can be achieved for a given number of change and what is the buffer occupancy associated with it?
# If choosing a bitrate leads to buffer underflow, it will not be conbsidered as a valid switch. 

class OptimalMetric:


    # Generate a list of throughputs with in periods of 30 each having a 
    # poisson distribution with a lambda in th_lambda_lst
    def generate_th(self, profile):

        if profile == 'prandom':  
            self.period = 30
            self.r_lst = [1500, 2000, 3000]
            self.th_lambda_lst = [1700, 1900, 2200, 2500, 2800, 3200]
            self.steps = self.period * len(self.th_lambda_lst)
            th_lst = np.array([], dtype=int)
            for th_lambda in self.th_lambda_lst:
                th_lst = np.concatenate((th_lst, np.random.poisson(th_lambda, self.period)))
        
        # Uncomment this part to see the throughput distribution
        #count, bins, ignored = plt.hist(th_lst)
        #plt.show()

        return th_lst


    def calculate(self, profile):
        res_past = {}
        res_curr = {}

        th_lst = self.generate_th(profile)

        for r in self.r_lst:
            res_past[r] = {0:{'r':r, 'buf':th_lst[0]/float(r)}} 

        # Each step the throughput changes and the bitrate can change or remain the same.
        # Using dynamic programming, this section calculate all path which do not cause underflow
        # and keep the buffer occupancy and accumulated bitrate.

        for i in range(1, self.steps):
            for r_curr in self.r_lst:
                for r_past in self.r_lst:
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

        # Calculate final results and save them in file with the columns associated with
        # change, bitrate, and buffer occupancy
        
        print("change bitrate buffer")
        for i in range(self.steps):
            maxr = 0
            entry = {}
            for p in res_past.keys():
                if (i in res_past[p]) and (res_past[p][i]['r'] > maxr):
                    maxr = res_past[p][i]['r']
                    entry = res_past[p][i]
            if entry:        
                hist[i] = entry
                hist[i]['r'] = hist[i]['r']/self.steps
                line = str(i) + ' ' + str(hist[i]['r']) + ' ' + str(hist[i]['buf'])
                print(line)

        return hist


if __name__ == "__main__":
    optm = OptimalMetric()
    hist = optm.calculate('prandom')

