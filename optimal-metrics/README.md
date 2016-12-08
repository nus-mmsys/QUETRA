# Problem definition in the context of video streaming rate adaptation

At each step in time, the throuhput (th) changes following the poisson distribution for a short period.
For each time window therefore, there will be a different arrival rate.

There are a list of bitrates (r) and bitrate can be switched at each time step or remain the same.

What is the maximum bitrate that can be achieved for a given number of change and what is the buffer occupancy associated with it?
If choosing a bitrate leads to buffer underflow, it will not be conbsidered as a valid switch. 

# Usage

    optmcalc.py <network profile> <video profile>
        network profiles: prandom, p1, p2, p3, p4
        video profiles:   t1, t2, t3, t4, t5, t6, t7

    optmplot.r <optimal result file name>
    
    evaluate-all.r <benchmark file name> [<path to optimal results>]
    
    evaluate-avgm.r <metric x> <metric y> <benchmark file name>
                    metrics: bitrate, change, stall, numStall, avgStall

## Example

    $ python optmcalc.py p1 t1 > p1-t1.csv
    $ ./optmplot.r p1-t1.csv
    
    $ ./evaluate-all.r benchmark-results/120.csv optimal-results
    
    $ ./evaluate-avgm.r bitrate avgStall benchmark-results/120.csv
