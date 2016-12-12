class BufferBased:

    def __init__(self, r_lst, buff_cap):
        self.r_lst = r_lst
        self.buff_cap = float(buff_cap)
        self.bitrate_count = len(r_lst)    
        self.buff_array = []
        self.low_res = self.buff_cap * (90.0/240.0) 
        self.up_res = self.buff_cap * (24.0/240.0)
        self.act_buff = self.buff_cap - (self.low_res + self.up_res) # cussion in algo
        self.buff_interval = self.act_buff / (self.bitrate_count - 1 ) # should have kept bitrate_count-2 as upper and lower reserve is fix
        self.min_index = 0

    def choose(self, cur_buff, th):        

        for j in range(self.bitrate_count):
            self.buff_array.append(0) #initilization 

        self.buff_array[0] =  self.low_res
        self.buff_array[self.bitrate_count - 1] = self.buff_cap - self.up_res

        for j in range(1, self.bitrate_count - 1):
            self.buff_array[j] = j * self.buff_interval + self.low_res

        k = 0
        fbuff_now = 0
        while cur_buff < self.buff_array[k] and k < self.bitrate_count - 1:
            fbuff_now = k
            k += 1
                 
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
            self.min_index = fbuff_now - 1
        elif fbuff_now <= minus_index:
            self.min_index =  fbuff_now + 1 

        return self.r_lst[self.min_index]
