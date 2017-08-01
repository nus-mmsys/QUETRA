This repository/directory contains the data and scripts used to produce the figures and results from the paper:

Praveen Kumar Yadav, Arash Shafiei, Wei Tsang Ooi, **QUETRA: A Queuing Theory Approach to DASH Rate Adaptation**, In Proceedings of ACM Multimedia 2017, Mountain View, CA, 23-27 October, 2017.

# Content

Here are the directories and their content:

-`raw-logs/`: Directory containing raw log files from the web browser for different buffer capacity in the corresponding sub-directory (e.g., `raw-logs/120` contains the log files from experiments with buffer capacity of 120s). Log files naming convention : <network profile>-<sample>-<algorithm>.log (e.g., p1-v4-bba.log).
  - `raw-logs/parseEvent.sh`: main script for extracting the results.  
  - `raw-logs/evalEvent.sh` and `raw-logs/csvCreate.sh`: supporting scripts for `parseEvent.sh`

-`code/`: Directory containing rate adaptation algorithms implementation.

-`plots/`: Directory contains already extracted csv file and R script file to generate graphs and compare the results.



# How to Parse the Browser Logs and Extract Information

Run the following command to parse  the browser logs:

    parseEvent.sh <output>

The command above parses the browser logs to filter out events relevant to us (segment arrival and playback quality changes).  `Dash.js` also logs the state of the buffers every 50 ms, which the command above filter out as well.  A _time-event_ log is created in the `event-<buffer capacity>` sub-directory (e.g., `event-120`) with filename `<event>-<profile>-<sample>-<method>.csv` (e.g., `event-p1-v4-abr.csv`).

The time-event logs contain, per line:

    timeStamp,repIndex,videoBitrate,bufferLength,throughput,event,bufferCapacity

where:

- `timeStamp` is the time the entry is logged by `Dash.js`
- `repIndex` is the index of the representation being played
- `videoBitrate` is the average bitrate of the representation being played
- `bufferLength` is the current buffer occupancy
- `throughput` is the throughput of the segment downloaded if this line corresponds to the segment arrival event, or is 0 otherwise.
- `event` is either `playing` or `arrival`.  `playing` corresponds to either a playback quality change event or a periodic log event, while `arrival` corresponds to the segment arrival event.
- `bufferCapacity` is the buffer capacity

The time-event logs are then used to produce the final results in a file named `<output>.csv` in the `result` directory, where each line has the following format:

    profile,sample,method,bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow,qoe,bufSize

- `profile` is either `p1`, ..., `p4`, referring to the network profile used
- `sample` is either `v1`, ..., `v7`, referring to the video samples used
- `method` is the name of the rate adaptation method
- `bitrate` is the average bitrate of downloaded segments
- `change` is the total number of changes in the representations
- `ineff` is the inefficiency in network utilization
- `stall` is the total stall duration (in seconds)
- `numStall` is the total number of stalls during the playback
- `avgStall` is `stall/numStall`
- `overflow` is the buffer full duration (in seconds)
- `numOverflow` is the number of times the buffer is full
- `qoe` is the QoE value calculated (see the paper for details)
- `bufSize` is the buffer capacity (in seconds)

A copy of of the final output is provided inside the `plot` directory, with filaname `results.csv`.

# How to Plot Figures in the Paper

In `plot` directory, use `plot.r` to plot the following figures (using data from `results.csv`).

- Figure 4: (X,Y)-plot of changes in representation versus bitrate, and stall duration versus number of stalls for different algorithms.
- Figure 5: QoE for different methods
- Figure 7: (X,Y)-plot of changes in representation versus bitrate for video V5
- Figure 8: Duration of buffer full for different methods
- Figure 9: (X,Y)-plot of changes in representation versus bitrate for different throughput prediction methods

The script `plot/plotCombinedBufferOcuupancy.r` takes three time-event logs as command line input and plots a graph with their buffer occupancy on the same scale. If the time-event logs for profile 2, sample 1 for quetra (i.e., `event-p2-v1-quetra.csv`) for different buffer capacities is given to the script, the graph will correspond to Figure 2 (Example of a case where buffer occupancy in QUETRA converges to K/2) in the paper.


# How to Integrate with Dash.js

Implementation code for QUETRA, BBA, and ELASTIC are available in `code` directory.  

To run `Dash.js` with these algorithms,
- get a copy of `Dash.js` v2.1.1 from `https://github.com/Dash-Industry-Forum/dash.js/releases/tag/v2.1.1`.
The rate adaptation methods are implemented for v2.1.1 but can be adopted for another version of `Dash.js`  
- follow the same structure as how `BolaRule.js` is integrated into `Dash.js` inside the directory `dash.js/src/streaming/rules/abr/` to integrate `quetra.js`, `bba.js`, and `elastic.js`.
- to change the default buffer capacity (30/60s), edit `MediaPlayerModel.js` located at `dash.js/src/streaming/models/` and change the value of
    - `BUFFER_TIME_AT_TOP_QUALITY_LONG_FORM` (when content is more than 10 minutes),
    - `BUFFER_TO_KEEP` (when content is less than 10 minutes)
- change `RICH_BUFFER_THRESHOLD`, `BUFFER_PRUNING_INTERVAL`, `DEFAULT_MIN_BUFFER_TIME_FAST_SWITCH`, `BUFFER_TIME_AT_TOP_QUALITY` by setting them equal to buffer capacity, as they are not applicable to ELASTIC, BBA, and QUETRA.
- to log the events into browser log, add the following lines into `main.js` in `dash.js/samples/dash-if-reference-player/app/`:



Note that the default variable provided by `Dash.js` are kept intact in the three rate adaptation algorithms above.
