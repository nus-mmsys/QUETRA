#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 2) {
  cat("\nusage: evaluate.r <path to optimal results> <benchmark file name>\n\n")
  quit()
}

benchdata <- read.csv(args[2], header = TRUE)
filename <- paste(args[2], '.pdf', sep="")
pdf(filename)

networkprof <- unique(benchdata[["profile"]])
videosample <- unique(benchdata[["sample"]])


for (p in networkprof) {
    for (t in videosample) {
        optdata <- read.csv(paste(args[1], "/", p, "-", t, ".csv", sep=""))
        optdata <- optdata[c("bitrate", "change")]
        benchsubdata <- subset(benchdata, profile==p & sample==t)
        benchsubdata <- benchsubdata[c("bitrate", "change", "method")]
        if (nrow(optdata) > 0) {
            optdata <- cbind(optdata, method="optimal")
            dt <- rbind(optdata, benchsubdata)
        } else {
            dt <- benchsubdata
        }
        plt <- ggplot()
        plt <- plt + geom_point(data=dt,
                aes(x=bitrate,
                y=change,
                color=method))
        plt <- plt + ggtitle(paste(p, "-", t, sep=""))
        print(plt)
       
    }
}

cat(paste("The file", filename,"is successfully generated.\n"))
