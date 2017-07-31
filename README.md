This repository / folder contains the data and scripts used to produce the figures and results from the paper:

Praveen Yadav, Arash Shafiei, Wei Tsang Ooi, **QUETRA: A Queuing Theory Approach to DASH Rate Adaptation**, In Proceedings of ACM Multimedia 2017, Mountain View, CA, 23-27 October, 2017.

Here are the folders and their content:

- `raw-logs/`: Directory containg raw log files from web browser for different buffer capacity in the correponding sub-directory and script for extracting the results. Log files naming convention : `<network profile>-<sample>-<algorithm>.log` (e.g., `p1-v4-bba.log`). Please note that buffer capacity is hard coded into logs.

- `code/`: Directory containing rate adaptaion algorithms implementation. 

- `plots/`: Directory contains already extrated csv file for differnt buffer capacity and R script file to generate graphs and compare the results.

## Browser Logs Extraction

- `raw-logs/parseEvent.sh`: Takes name of the "output" file as command line argument. Parse the raw browser log files from current directory into time-event csv file. It also calls `evalEvent.sh` and `csvCreate.sh` to extract the informatin from time-event csv files and create "output file name".csv file in `result` directory. The time-event csv file are located inside `event-<buffer capacity>` (e.g., `event-120`) directory.   

## R Scripts

- `plot/colorRampPaletteAlpha.R`: R script file to support color pallets. 

- `plot/results.csv`: Output in the form of `profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe,bufSize` for all buffer capacities.

- `/plot/plot.r`: Plots following figure used in the paper
    * Figure 4: (X,Y)-plot of changes in representation versus bitrate, and stall duration versus number of stalls for different algorithms.
    * Figure 5: QoE for different methods
    * Figure 7: (X,Y)-plot of changes in representation versus bitrate for video V5
    * Figure 8: Duration of buffer full for different methods
    * Figure 9: (X,Y)-plot of changes in representation versus bitrate for different throughput prediction methods

- `plot/plotCombinedBufferOcuupancy.r`: Takes three event files and plot a graph with their buffer occupancy on the same scale. The graph corresponds to Figure 2 (Example of a case where buffer occupancy in QUETRA converges to K/2) in the paper.

## Implementation 

* Implementation code for QUETRA, BBA, and ELASTIC are available in `code` directory. 
* The rate adaptations algorithms above are implementated for `Dash.js` v2.1.1 but can be adopted in different version of `Dash.js`  
* The default variable provided by `Dash.js` are kept intact in the three rate adaptation algorithms above.
* To integrate these rate adaptation algorithms into `Dash.js`, you can follow the same structure as how `BolaRule.js` is integrated into `Dash.js` inside the folder `dash.js/src/streaming/rules/abr/`
* Buffer capacity can be changed in `MediaPlayerModel.js` file located at `dash.js/src/streaming/models/` by changing the value of
    - `BUFFER_TIME_AT_TOP_QUALITY_LONG_FORM` (when content is more than 10 minutes), 
    - `BUFFER_TO_KEEP` (when content is less than 10 minutes)
* Change `RICH_BUFFER_THRESHOLD`, `BUFFER_PRUNING_INTERVAL`, `DEFAULT_MIN_BUFFER_TIME_FAST_SWITCH`, `BUFFER_TIME_AT_TOP_QUALITY` by setting them equal to buffer capacity, as they are not applicable to ELASTIC, BBA, and QUETRA. 
