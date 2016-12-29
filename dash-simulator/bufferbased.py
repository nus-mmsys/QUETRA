class BufferBased:

    def __init__(self, r_lst, buff_cap):
        self.r_lst = r_lst
        self.buff_cap = float(buff_cap/1000)
        self.bitrate_count = len(r_lst)    
        self.buff_array = []
        self.low_res = self.buff_cap * (90.0/240.0) 
        self.up_res = self.buff_cap * (24.0/240.0)
        self.act_buff = self.buff_cap - (self.low_res + self.up_res) # cussion in algo
        self.buff_interval = self.act_buff / (self.bitrate_count - 1 ) # should have kept bitrate_count-2 as upper and lower reserve is fix
        self.min_index = 0
        self.plus_index = 0
        self.minus_index = 0

    def mapBitrate(self,cur_buff): 
        self.returnBitrate = 0
        self.returnBitrate=self.r_lst[0]+(((self.r_lst[self.bitrate_count-1]-self.r_lst[0])/(self.buff_cap - self.low_res - self.up_res)) * (cur_buff - self.low_res))
        return self.returnBitrate

    def choose(self, cur_buff, th):  
        
        cur_buff = cur_buff/1000      
        self.low_res = self.low_res 
        self.up_res =  self.up_res 
        self.act_buff =  self.buff_cap - self.low_res - self.up_res -  self.up_res
        k = 0
        fbuff_now = self.mapBitrate(cur_buff)
        plus_index = 0
        minus_index = 0                                        
        if self.min_index == self.bitrate_count - 1:
            plus_index = self.bitrate_count - 1
        else:
            plus_index = self.min_index + 1                             

        if self.min_index == 0:
            minus_index = 0
        else:
            minus_index = self.min_index - 1

        if cur_buff <= self.low_res:
            self.min_index = 0
        elif cur_buff >= self.act_buff + self.low_res:
            self.min_index = self.bitrate_count - 1
        elif fbuff_now >= plus_index:
            k = 0
            while k < self.bitrate_count  and self.r_lst[k] < fbuff_now:
                   self.min_index = k
                   k = k + 1
        elif fbuff_now <= minus_index:
            i = self.bitrate_count - 1
            while i >= 0 and self.r_lst[i] > fbuff_now:
                   self.min_index = i
                   i = i - 1

        return self.min_index
