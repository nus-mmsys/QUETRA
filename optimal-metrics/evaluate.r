#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
    cat("\nusage: evaluate.r <benchmark file name> [<path to optimal results>]\n\n")
    quit()
}

optimalpath <- ""
optdata <- data.frame()
if (length(args) == 2) {
    optimalpath <- args[2]  
}

benchdata <- read.csv(args[1], header = TRUE)
filename <- paste(args[1], '.pdf', sep="")
pdf(filename)

networkprof <- unique(benchdata[["profile"]])
videosample <- unique(benchdata[["sample"]])


for (p in networkprof) {
    for (t in videosample) {

        if (optimalpath != "") {
            optdata <- read.csv(paste(optimalpath, "/", p, "-", t, ".csv", sep=""))
            optdata <- optdata[c("bitrate", "change")]
        }

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
