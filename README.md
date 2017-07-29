# Files

Here are the folders and their content:

/experimental log files/"Buffer Capacity" :Directory containg raw log files from web browser for different buffer capacity. Naming convention : "NetworkProfile" - "Sample" - "Algorithm".log. Please note that buffer capacity is hard coded into logs.

/RPlot_script : Directory contains already extrated csv file for differnt buffer capacity and R script file to generate graphs and compare the results.



## ```browser-logs extraction```


parseEvent.sh : Takes name of the "output" file as command line argument. Parse the raw browser log files from current directory into time-event csv file. The time-event  csv file are located inside graph/"output" directory. It also calls evalEvent.sh and csvCreate.sh to extract the informatin from time-event  csv files and create "output file name".csv file in /RESULT directory.  

## ```Extracted logs```
/RPlot_script/30-60.csv : Output in the form of `profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe` for buffer capacity of 30/60s.

/RPlot_script/120.csv : Output in the form of `profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe` for buffer capacity of 120s.

/RPlot_script/240.csv : Output in the form of `profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe` for buffer capacity of 240s.

/RPlot_script/result.csv : Output in the form of `profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe,bufSize` for all buffer capacities.


## ```R-scripts```

/RPlot_script/colorRampPaletteAlpha.R : R script file to support color pallets. 

/RPlot_script/plot.r : Plots following figure used in **QUETRA: A Queuing Theory Approach to DASH Rate Adaptation**
* Figure 4: (X,Y)-plot of changes in representation versus bitrate, and stall duration versus number of stalls for different algorithms.
* Figure 5: QoE for different methods
* Figure 7: (X,Y)-plot of changes in representation versus bitrate for video V5
* Figure 8: Duration of buffer full for different methods
* Figure 9: (X,Y)-plot of changes in representation versus bitrate for different throughput prediction methods

/RPlot_script/plotCombinedBufferOcuupancy.r : Takes three event files and plot a glrah with their buffer occupancy on the same scale. The graph corresponds to following figure in the paper.
* Figure 2: Example of a case where buffer occupancy in QUETRA converges to K/2.






