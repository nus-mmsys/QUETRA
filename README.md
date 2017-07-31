This repository/directory contains the data and scripts used to produce the figures and results from the paper:

Praveen Kumar Yadav, Arash Shafiei, Wei Tsang Ooi, **QUETRA: A Queuing Theory Approach to DASH Rate Adaptation**, In Proceedings of ACM Multimedia 2017, Mountain View, CA, 23-27 October, 2017.

# Content

Here are the directories and their content:

-`raw-logs/`: Directory containing raw log files from the web browser for different buffer capacity in the corresponding sub-directory and script for extracting the results. Log files naming convention : <network profile>-<sample>-<algorithm>.log (e.g., p1-v4-bba.log). 

-`code/`: Directory containing rate adaptation algorithms implementation.

-`plots/`: Directory contains already extracted csv file and R script file to generate graphs and compare the results.



# How to Parse the Browser Logs and Extract Information

Run following scripts to parse  the browser logs:

-`raw-logs/parseEvent.sh`: The script takes output filename output as command line argument. It parse the raw browser log files to create time-event csv file (e.g., event-p1-v1-abr.csv) in the form of  `timeStamp,repIndex,videoBitrate,bufferLength,throughput,event,bufferCapacity` inside `event-<buffer capacity>` (e.g., event-120) directory. `raw-logs/parseEvent.shparseEvent.sh` calls `raw-logs/evalEvent.sh` and `raw-logs/csvCreate.sh` to extract the information from time-event csv files and create <output>.csv file in the form of `profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe,bufSize` for all buffer capacities in the result directory.



# How to Plot Figures in the Paper

Run the following R scripts to generate the figures:

- `/plot/plot.r`: The script plots the following figure used in the paper
    * Figure 4: (X,Y)-plot of changes in representation versus bitrate, and stall duration versus number of stalls for different algorithms.
    * Figure 5: QoE for different methods
    * Figure 7: (X,Y)-plot of changes in representation versus bitrate for video V5
    * Figure 8: Duration of buffer full for different methods
    * Figure 9: (X,Y)-plot of changes in representation versus bitrate for different throughput prediction methods

- `plot/plotCombinedBufferOcuupancy.r`: The script takes three event files as command line input and plots a graph with their buffer occupancy on the same scale. The graph corresponds to Figure 2 (Example of a case where buffer occupancy in QUETRA converges to K/2) in the paper.




# How to Integrate with Dash.js

* Implementation code for QUETRA, BBA, and ELASTIC are available in `code` directory. 
* The rate adaptations algorithms above are implemented for `Dash.js` v2.1.1 but can be adopted in different version of `Dash.js`  
* The default variable provided by `Dash.js` are kept intact in the three rate adaptation algorithms above.
* To integrate these rate adaptation algorithms into `Dash.js`, you can follow the same structure as how `BolaRule.js` is integrated into `Dash.js` inside the directory `dash.js/src/streaming/rules/abr/`
* Buffer capacity can be changed in `MediaPlayerModel.js` file located at `dash.js/src/streaming/models/` by changing the value of
    - `BUFFER_TIME_AT_TOP_QUALITY_LONG_FORM` (when content is more than 10 minutes), 
    - `BUFFER_TO_KEEP` (when content is less than 10 minutes)
* Change `RICH_BUFFER_THRESHOLD`, `BUFFER_PRUNING_INTERVAL`, `DEFAULT_MIN_BUFFER_TIME_FAST_SWITCH`, `BUFFER_TIME_AT_TOP_QUALITY` by setting them equal to buffer capacity, as they are not applicable to ELASTIC, BBA, and QUETRA. 
