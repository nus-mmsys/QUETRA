#!/usr/bin/env python

import sys
import os.path
import numpy as np
import matplotlib.pyplot as plt

# Problem definition in the context of video streaming rate adaptation

# At each step in time, the throuhput (th) changes following the poisson distribution for a short period. 
# For each time window therefore, there will be a different arrival rate.

# There are a list of bitrates (r) and bitrate can be switched at each time step or remain the same.

# What is the maximum bitrate that can be achieved for a given number of change and what is the buffer occupancy associated with it?
# If choosing a bitrate leads to buffer underflow, it will not be conbsidered as a valid switch. 

class OptimalMetric:

    def generate_r(self, profile):

        r_lst = []

        if profile == 't1':
            r_lst = [1200, 2200, 4100]
        if profile == 't2':
            r_lst = [1622, 2313, 4077]
        if profile == 't3':
            r_lst = [1198, 1974, 4103]
        if profile == 't4':
            r_lst = [1143, 1795, 4140]
        if profile == 't5':
            r_lst = [342, 577, 946, 1784, 2116]
        if profile == 't6':
            r_lst = [254, 344, 452, 706, 1015, 1460, 2102]
        if profile == 't7':
            r_lst = [315, 722, 1498, 2460, 3413]
        
        return r_lst

    # For random profile (prandom) Generate a list of throughputs with in periods of 30 each having a 
    # poisson distribution with a lambda in th_lambda_lst
    # For profiles 1 to 4, it generates throughputs as described in the paper.

    def generate_th(self, profile):

        profile_path = './network-profiles/'

        th_lst = np.array([], dtype=int)

        if profile == 'prandom':  
            period = 30
            th_init_lst = [1700, 1900, 2200, 2500, 2800, 3200]
            for th in th_init_lst:
                th_lst = np.concatenate((th_lst, np.random.poisson(th, period)))
        else:
            filename = profile_path + profile + '.csv'
            if not os.path.isfile(filename):
                return th_lst
    
            f = open(filename)

            f.readline()
            lines = f.readlines()
            for line in lines:
                line = line.replace('\n', '')
                line = line.replace(' ', '')
                entry = line.split(',')
                for i in range(int(entry[1])):
                    th_lst = np.append(th_lst, int(entry[0]))
            f.close()        

        # Uncomment this part to see the throughput distribution
        #count, bins, ignored = plt.hist(th_lst)
        #plt.show()

        return th_lst


    def calculate(self, nprofile, vprofile):
        res_past = {}
        res_curr = {}
        hist = {}

        th_lst = self.generate_th(nprofile)
        steps = th_lst.size       
  
        if steps < 1:
            print("network profile is not valid.")
            return hist

        r_lst = self.generate_r(vprofile)

        if len(r_lst) < 1:
            print("video profile is not valid.")
            return hist

        for r in r_lst:
            res_past[r] = {0:{'r':r, 'buf':th_lst[0]/float(r)}} 

        # Each step the throughput changes and the bitrate can change or remain the same.
        # Using dynamic programming, this section calculate all path which do not cause underflow
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
 
        # Calculate final results and save them in file with the columns associated with
        # change, bitrate, and buffer occupancy
        
        print("change, bitrate, buffer")
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
                line = str(i) + ', ' + str(hist[i]['r']) + ', ' + str(hist[i]['buf'])
                print(line)

        return hist


if __name__ == "__main__":
    
    if (len(sys.argv) < 3):
        print("\nusage: %s <network profile> <video profile>\n" % sys.argv[0])
        print("       network profiles: prandom, p1, p2, p3, p4")
        print("       video profiles:   t1, t2, t3, t4\n")
        exit()
    optm = OptimalMetric()
    hist = optm.calculate(sys.argv[1], sys.argv[2])

