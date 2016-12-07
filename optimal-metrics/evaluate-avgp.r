#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  cat("\nusage: evaluate-avgp.r <benchmark file name>\n\n")
  quit()
}

benchdata <- read.csv(args[1], header = TRUE)
filename <- paste(args[1], '-avgp.pdf', sep="")
pdf(filename)

videosample <- unique(benchdata[["sample"]])

for (t in videosample) {

    dt <- data.frame()
    benchsum <- subset(benchdata, sample==t)
    benchsum <- benchsum[c("bitrate", "change", "method")]

    methods <- unique(benchsum[["method"]])
    # Filter by method
    #methods <- c("gd", "kama", "qlast", "bola", "bb", "elastic")

    for(m in methods) {
        row <- subset(benchsum, method==m)
        mean <- colMeans(row[c("bitrate", "change")])
        meanrow <- data.frame(bitrate=c(mean["bitrate"]),
                              change=c(mean["change"]),
                              method=m)
        dt <- rbind(dt, meanrow)
    }
    plt <- ggplot()
    plt <- plt + geom_point(data=dt,
            aes(x=bitrate,
            y=change,
            color=method))
    plt <- plt + ggtitle(paste(t, sep=""))
    print(plt)
}

cat(paste("The file", filename,"is successfully generated.\n"))
