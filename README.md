# Raw logs 

Here are the folders and their content:

/experimental log files/"Buffer Capacity" :Directory containg raw log files from web browser for different buffer capacity. Naming convention : "NetworkProfile" - "Sample" - "Algorithm".log. Please note that buffer capacity is hard coded into logs.

/RPlot_script : Directory contains already extrated csv file for differnt buffer capacity and R script file to generate graphs and compare the results.



## Browser-logs extraction


parseEvent.sh : Takes name of the "output" file as command line argument. Parse the raw browser log files from current directory into time-event csv file. The time-event  csv file are located inside graph/"output" directory. It also calls evalEvent.sh and csvCreate.sh to extract the informatin from time-event  csv files and create "output file name".csv file in /RESULT directory.  

/RPlot_script/result.csv : Output in the form of `profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe,bufSize` for all buffer capacities.


## R-scripts

/plot/colorRampPaletteAlpha.R : R script file to support color pallets. 

/plot/plot.r : Plots following figure used in **QUETRA: A Queuing Theory Approach to DASH Rate Adaptation**
* Figure 4: (X,Y)-plot of changes in representation versus bitrate, and stall duration versus number of stalls for different algorithms.
* Figure 5: QoE for different methods
* Figure 7: (X,Y)-plot of changes in representation versus bitrate for video V5
* Figure 8: Duration of buffer full for different methods
* Figure 9: (X,Y)-plot of changes in representation versus bitrate for different throughput prediction methods

/plot/plotCombinedBufferOcuupancy.r : Takes three event files and plot a glrah with their buffer occupancy on the same scale. The graph corresponds to following figure in the paper.
* Figure 2: Example of a case where buffer occupancy in QUETRA converges to K/2.

## Implementation Code

* Implementation code is available in code directory. 
* Algorithm files are prepared for implementation in `Dash.js v2.1.1` but can be implemented in different versions as well. 
* The default varibale provided by Dash.js are not kept intact. 
* These files can be implemented in the same way as BolaRule.js in the folder *dash.js/src/streaming/rules/abr/*
* Buffer capacity can be changed in `MediaPlayerModel.js` file located at *dash.js/src/streaming/models/* by changing **BUFFER_TIME_AT_TOP_QUALITY_LONG_FORM** (when content is more than 10 minutes), **BUFFER_TO_KEEP**(when content is less than 10 minutes)
* Change **RICH_BUFFER_THRESHOLD, BUFFER_PRUNING_INTERVAL, DEFAULT_MIN_BUFFER_TIME_FAST_SWITCH, BUFFER_TIME_AT_TOP_QUALITY** by setting them equal to buffer capacity, as they are not applicable to ELASTIC,BBA and QUETRA. 
* Verify the actual buffer capity before running the expriment as changing the variables may cause bugs. 
* Keep track of Dash.js Github page https://github.com/Dash-Industry-Forum/dash.js  for updates on bugs and their fixes. 







