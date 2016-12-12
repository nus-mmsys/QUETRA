#!/usr/bin/env python

import sys
import os.path
import numpy as np
import matplotlib.pyplot as plt
from rafactory import rafactory as raf

class DashSimulator:

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

    # generate the list of throughput for double of video duration
    # TODO: video duration should be added as argument
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


    def calculate(self, method, nprofile, vprofile, buff_cap):

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

        raa = raf.create(method, r_lst, buff_cap)

        if raa is None:
            print("method is not valid.")
            return hist

        cur_buff = 0.0
        num_stall = 0
        chosen_r_lst = []
        for i in range(1, steps):
            chosen_r = raa.choose(cur_buff, th_lst[i])

            chosen_r_lst.append(chosen_r)
            cur_buff = cur_buff + (float(th_lst[i]) / float(chosen_r)) - 1
            
            if cur_buff < 0 :
                cur_buff = 0
                num_stall += 1
           
        bitrate_avg = sum(chosen_r_lst) / float(len(chosen_r_lst))
        print("profile,sample,method,bitrate,numStall")
        row = nprofile + "," + vprofile + "," + method + "," + str(bitrate_avg) + "," + str(num_stall)
        print(row)
        

if __name__ == "__main__":
    
    if (len(sys.argv) < 4):
        print("\nusage: %s <method> <network profile> <video profile> <buffer capacity>\n" % sys.argv[0])
        print("       method:           bba, elastic, quetra, abr, bola")
        print("       network profiles: prandom, p1, p2, p3, p4")
        print("       video profiles:   t1, t2, t3, t4\n")
        exit()
    optm = DashSimulator()
    hist = optm.calculate(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
