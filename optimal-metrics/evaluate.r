#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 2) {
  cat("\nusage: evaluate.r <path to optimum results> <benchmark file name>\n\n")
  quit()
}

networkprof <- c("p1", "p2", "p3", "p4")
videoprof <- c("t1", "t2", "t3", "t4", "t5", "t6", "t7")

benchdata <- read.csv(args[2], header = TRUE)

pdf("evaluate.pdf")

for (p in networkprof) {
    for (t in videoprof) {
        optdata <- read.csv(paste(args[1], "/", p, "-", t, ".csv", sep=""))
        benchsubdata <- subset(benchdata, network==p & video==t)
        plt <- ggplot() 
        plt <- plt + geom_point(data=benchsubdata,
                aes(x=bitrate,
                y=change))
        plt <- plt + geom_point(data=optdata,
                aes(x=bitrate,
                y=change))
        plt <- plt + ggtitle(paste(p, "-", t, sep=""))
        print(plt)
       
    }
}

cat(paste("The file evaluate.pdf is successfully generated.\n"))
