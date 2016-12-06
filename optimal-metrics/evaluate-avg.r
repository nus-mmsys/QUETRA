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
filename <- paste(args[2], '.pdf', sep="")
pdf(filename)

for (t in videoprof) {
    optsum = data.frame()
    for (p in networkprof) {
        optdata <- read.csv(paste(args[1], "/", p, "-", t, ".csv", sep=""))
        optdata <- optdata[c("bitrate", "change")]
        optsum <- rbind(optsum, optdata)
    }
    optmean <- data.frame()
    optmean <- colMeans(optsum)
    optmean <- cbind(optmean, method="optimum")

    #print(optmean)
    benchsum <- subset(benchdata, sample==t)
    benchsum <- benchsum[c("bitrate", "change", "method")]

    benchmean <- data.frame()
    #print(benchsum)
    for (m in unique(benchsum["method"])) {
        meanrow <- subset(benchsum, "method"==m)
        #print(meanrow)
        #meanrow <- colMeans()
        #print(meanrow)
        #benchmean <- rbind(benchmean, meanrow)
    }
    #print(benchmean)
    #dt <- rbind(optmean, benchmean)
    #plt <- ggplot()
    #plt <- plt + geom_point(data=dt,
    #        aes(x=bitrate,
    #        y=change,
    #        color=method))
    #plt <- plt + ggtitle(paste(t, sep=""))
    #print(plt)
}

cat(paste("The file", filename,"is successfully generated.\n"))
