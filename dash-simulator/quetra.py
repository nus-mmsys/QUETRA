import math
class Quetra:
    
    def __init__(self, r_lst, buff_cap):
        self.r_lst = r_lst
        self.buff_cap = float(buff_cap/1000)
        self.bitrate_count = len(r_lst)    
        self.buff_array = []
        self.low_res = self.buff_cap * (90.0/240.0) 
        self.min_index = 0
        self.rhoArray = []
        self.slack = []
        self.slack30 =[29.25,29.2246,29.1983,29.1712,29.143,29.1139,29.0836,29.0522,29.0195,28.9855,28.95,28.9129,28.8742,28.8336,28.7911,28.7464,28.6994,28.6498,28.5975,28.5421,28.4833,28.4209,28.3543,28.2832,28.2069,28.125,28.0367,27.9411,27.8373,27.7241,27.6001,27.4636,27.3125,27.1444,26.9562,26.744,26.5031,26.2277,25.9103,25.542,25.1119,24.6069,24.0121,23.3115,22.4893,21.5325,20.4347,19.1998,17.8455,16.4048,14.9228,13.451,12.039,10.7266,9.54002,8.4909,7.57875,6.79468,6.12517,5.55493,5.06895,4.65353,4.29676,3.9886,3.72075,3.48639,3.28001,3.09712,2.93406,2.78786,2.65609];
        self.slack60 =[59.25,59.2246,59.1983,59.1712,59.143,59.1139,59.0836,59.0522,59.0195,58.9855,58.95,58.9129,58.8742,58.8336,58.7911,58.7464,58.6994,58.6498,58.5975,58.5421,58.4833,58.4209,58.3543,58.2831,58.2069,58.125,58.0367,57.9411,57.8373,57.7241,57.6,57.4634,57.3122,57.1438,56.955,56.7417,56.4986,56.2189,55.8934,55.5096,55.0503,54.4904,53.7932,52.9034,51.736,50.1614,47.9911,44.984,40.9181,35.7703,29.92,24.1077,19.0476,15.0712,12.1288,9.99749,8.44445,7.2892,6.40712,5.71575,5.16083,4.70615,4.32698,4.006,3.73079,3.49221,3.28339,3.09909,2.93521,2.78854,2.65649];
        self.slack120 =[119.25,119.225,119.198,119.171,119.143,119.114,119.084,119.052,119.02,118.985,118.95,118.913,118.874,118.834,118.791,118.746,118.699,118.65,118.598,118.542,118.483,118.421,118.354,118.283,118.207,118.125,118.037,117.941,117.837,117.724,117.6,117.463,117.312,117.144,116.955,116.742,116.499,116.219,115.893,115.51,115.05,114.489,113.79,112.892,111.697,110.026,107.527,103.433,95.9794,81.9,59.9193,38.0624,24.1326,16.7349,12.6553,10.1631,8.49674,7.3058,6.41242,5.71746,5.16138,4.70633,4.32703,4.00602,3.7308,3.49221,3.28339,3.09909,2.93521,2.78854,2.65649];
        self.slack240 =[239.25,239.225,239.198,239.171,239.143,239.114,239.084,239.052,239.02,238.985,238.95,238.913,238.874,238.834,238.791,238.746,238.699,238.65,238.598,238.542,238.483,238.421,238.354,238.283,238.207,238.125,238.037,237.941,237.837,237.724,237.6,237.463,237.312,237.144,236.955,236.742,236.499,236.219,235.893,235.51,235.05,234.489,233.79,232.892,231.697,230.025,227.52,223.349,215.026,191.972,119.922,48.139,25.1488,16.8318,12.6646,10.1641,8.49683,7.30581,6.41242,5.71746,5.16138,4.70633,4.32703,4.00602,3.7308,3.49221,3.28339,3.09909,2.93521,2.78854,2.65649];

    def choose(self, cur_buff, th):  
       cur_buff = cur_buff/1000      
       self.low_res = self.low_res 
      
       if cur_buff <= self.low_res:
           return self.r_lst[0] 


       if self.buff_cap == 30 :
          self.slack = self.slack30


       if self.buff_cap == 60 :
          self.slack = self.slack60


       if self.buff_cap == 120 :
          self.slack = self.slack120


       if self.buff_cap == 240 :
          self.slack = self.slack240
    
    
       for j in range(self.bitrate_count):
            self.rhoArray.append(0) #initilization 
            self.buff_array.append(0) #initilization 

       for j in range(self.bitrate_count):
            self.rhoArray[j] = th/self.r_lst[j]
    
       for i in range(self.bitrate_count):
            rho = self.rhoArray[i]
            slackIndex = 0
	    if rho < 0.5 :
	       self.buff_array[i] = self.buff_cap
	    elif rho >=1.2 :
	       self.buff_array[i] = 0
	    else :
               slackIndex = int(math.floor((rho-0.5)/0.01))
	       self.buff_array[i] = self.slack[slackIndex]
	    print(str(i)+" slack   "+str(self.buff_array[i]))

       self.min_index = 0
       minDiff = math.fabs(cur_buff-self.buff_array[self.min_index]) 

       for i in range(self.bitrate_count):
	if math.fabs(cur_buff-self.buff_array[i])<=minDiff :
           self.min_index = i;
           minDiff =  math.fabs(cur_buff-self.buff_array[self.min_index])
	   	
       if self.buff_array[self.min_index] == self.buff_cap and self.buff_array[self.min_index] == self.buff_array[0] : 
	   self.min_index=0
           print("err")
       print("min_index  "+str(self.min_index)+" slack  "+ str(self.buff_array[self.min_index])+"buffer  "+ str(cur_buff) )  


       return self.r_lst[self.min_index]
