#!/usr/bin/env python

import sys
import os.path
import numpy as np
import random
import matplotlib.pyplot as plt
from rafactory import rafactory as raf
import math
from scipy.stats import poisson
class DashSimulator:

    def generate_r(self, profile):

        r_lst = []
        duration = 0
        segment = 0

        if profile == 't1':
            r_lst = [1200, 2200, 4100]
	    duration = 594
            segment = 2
        if profile == 't2':
            r_lst = [1622, 2313, 4077]
            duration = 654
            segment = 5
        if profile == 't3':
            r_lst = [1198, 1974, 4103]
            duration = 654
            segment = 2
        if profile == 't4':
            r_lst = [1143, 1795, 4140]
            duration = 594
            segment = 5
        if profile == 't5':
            r_lst = [342, 577, 946, 1784, 2116]
            duration = 244
            segment = 4
        if profile == 't6':
            r_lst = [254, 344, 452, 706, 1015, 1460, 2102, 3034, 5178, 6193]
            duration = 634
            segment = 3
        if profile == 't7':
            r_lst = [315, 722, 1498, 2460, 3413]
            duration = 653
            segment = 1.933
        
        return r_lst,duration,segment

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
                for i in range(1000 * int(entry[1])):
                    th_lst = np.append(th_lst, int(entry[0]))
            f.close()        

        # Uncomment this part to see the throughput distribution
        #count, bins, ignored = plt.hist(th_lst)
        #plt.show()

        return th_lst


    def calculate(self, method, nprofile, vprofile, buff_cap):

        hist = {}

        th_lst = self.generate_th(nprofile)

        r_lst,duration,segment = self.generate_r(vprofile)
        #duration = self.generate_r(vprofile)
        #segment = self.generate_r(vprofile)
       
        buff_cap = buff_cap * 1000      
        steps = duration * 1000
        segment = segment * 1000
        
        #steps = th_lst.size 
        
        if steps < 1:
            print("network profile is not valid.")
            return hist
        if len(r_lst) < 1:
            print("video profile is not valid.")
            return hist
        raa = raf.create(method, r_lst, buff_cap)
        if raa is None:
            print("method is not valid.")
            return hist
        cur_buff = 0.0
        temp_buff=0.0
        num_stall = 1
        stall = 0
        old_r=r_lst[0]
        r_index = 0
        old_r_index = 0
        chosen_r_lst = []
        i = 0
        k = 0
        flag = 0
        next_arrival = 0
        change = 0
        bitrate_sum = 0
        old_buff = 0
        #for i in range(1, steps):
        while i < steps:
            
            
            #print(str(i)+ "," +str(steps)) 

            if k >= len(th_lst) :
                k = 0

            arrival = random.expovariate((1000 * float(th_lst[k]))/(segment * (float(old_r))))
            #arrival = poisson.rvs(float(th_lst[k]) / (float(old_r)),size=1,random_state=None)
            #arrival = random.expovariate(0.5)
            if next_arrival == 0 :
                next_arrival = i + arrival*1000
            
            if i >= next_arrival :
                #temp_buff=temp_buff + (1000 * (float(th_lst[k]) / float(old_r))) #thlist 
                temp_buff = segment
                next_arrival = 0
            if cur_buff < steps - i :
		    if cur_buff < buff_cap and temp_buff >= segment :
			cur_buff = cur_buff + segment
			temp_buff = 0
		    
		    if cur_buff > buff_cap : 
		       cur_buff = buff_cap           
	   
		    r_index = raa.choose(cur_buff, th_lst[k])
                    #print("min_index  "+str(r_index))
                    chosen_r = r_lst[r_index]
		    if chosen_r <> old_r :
		       change = change + math.fabs(old_r_index - r_index)
			
		    
		    chosen_r_lst.append(chosen_r)
		    old_r = chosen_r
		    old_r_index = r_index
		    if cur_buff > 500 :
		       flag =1

		    if flag == 1 and cur_buff < 500 :
			steps = steps + 5
                        stall = stall + 5
                        if old_buff <> cur_buff :
			  num_stall += 1
			

		    cur_buff = cur_buff - 5
                    old_buff = cur_buff
		    if cur_buff < 0 :
		       cur_buff = 0

            bitrate_sum = bitrate_sum + (5 *chosen_r)

            i = i + 5  
            k = k + 5 
            
        #bitrate_avg = sum(chosen_r_lst) / float(len(chosen_r_lst))
        bitrate_avg = bitrate_sum / float(steps)
        print("profile,sample,method,bitrate,change,numStall,stall_duration,average_stall")
        row = nprofile + "," + vprofile + "," + method + "," + str(bitrate_avg) + "," + str(change) + "," + str(num_stall-1) + "," + str(stall/1000) + "," + str(stall/(num_stall*1000))
        print(row)
        

if __name__ == "__main__":
    
    if (len(sys.argv) < 4):
        print("\nusage: %s <method> <network profile> <video profile> <buffer capacity>\n" % sys.argv[0])
        print("       method:           bba, elastic, quetra, abr, bola")
        print("       network profiles: prandom, p1, p2, p3, p4")
        print("       video profiles:   t1, t2, t3, t4\n")
        exit()
    optm = DashSimulator()
    hist = optm.calculate(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]))
