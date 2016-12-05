# Problem definition in the context of video streaming rate adaptation

At each step in time, the throuhput (th) changes following the poisson distribution for a short period.
For each time window therefore, there will be a different arrival rate.

There are a list of bitrates (r) and bitrate can be switched at each time step or remain the same.

What is the maximum bitrate that can be achieved for a given number of change and what is the buffer occupancy associated with it?
If choosing a bitrate leads to buffer underflow, it will not be conbsidered as a valid switch. 

# Usage

    optm.py <network profile> <video profile>
        network profiles: prandom, p1, p2, p3, p4
        ideo profiles:   t1, t2, t3, t4

    plot.r <file name>

## Example

    $ python optm.py p1 t1 > exp.csv
    $ ./plot.r exp.csv
