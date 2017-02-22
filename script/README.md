# Files

Here are the folders and their content:

/experimental log files/<Buffer Capacity> :Directory containg raw log files from web browser for different buffer capacity. Naming convention : <NetworkProfile> - <Sample> - <Algorithm>.log. Please note that buffer capacity is hard coded into logs.

/RPlot_script : Directory contains already extrated csv file for differnt buffer capacity and R script file to generate graphs and compare the results.



## ```browser-logs extraction```


parse_event.sh : Takes name of the <output> file as command line argument. Parse the raw browser log files from current directory into time-event csv file. The time-event  csv file are located inside graph/<output> directory. It also calls eval_event.sh and csvCreate.sh to extract the informatin from time-event  csv files and create <output file name>.csv file in /RESULT directory.  

plotGraph.sh : Takes path of the <event directory> as command line argument. It calls the /RPlot_script/plotBitrateThroughput.r and /RPlot_script/plotBufferOccupancy.r to generate buffer occupancy and Bitrate-Throughput graph in /graph/<event directory> _<graph>


## ```R-scripts```

/RPlot_script/plotBitrateThroughput.r: Takes a time-event csv file as command line input to generate Bitrate-Throughput graph over the playback time

/RPlot_script/plotBufferOccupancy.r: Takes a time-event csv file as command line input to generate buffer occupancy graph over the playback time

/RPlot_script/allBar.r : Takes csv data file as command line input and genrerate bar graphs for all parameters in different network profile and samples combination.

/RPlot_script/avgBar.r : Takes matric, output file name and csv data file as command line input and genrerate bar graphs for the parameter averaged across all profiles and samples

/RPlot_script/allxy.r : Takes x-matric,y-matrics, size-matrics, output file name and csv data file as command line input and genrerate differnt x-y plots for all network profile and samples.

/RPlot_script/avgXYPlot.r : Takes x-matric,y-matrics, size-matrics, output file name and csv data file as command line input and genrerate differnt x-y plots averaged across all network profile and samples.

/RPlot_script/sample.r : Takes x-matric,y-matrics, size-matrics, sample number and csv data file as command line input and genrerate differnt x-y plots for a sample averaged across all network profile.

/RPlot_script/legend.r : Takes x-matric,y-matrics, size-matrics, output file name and csv data file as command line input and genrerate legend only for the plot.

/RPlot_script/colorRampPaletteAlpha.R : R script file to support color pallets. 

# How to Run

