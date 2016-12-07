#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  cat("\nusage: evaluate-avgm.r <benchmark file name>\n\n")
  quit()
}

benchdata <- read.csv(args[1], header = TRUE)
filename <- paste(args[1], '-avgm.pdf', sep="")
pdf(filename)

methods <- unique(benchdata[["method"]])
#methods <- c("gd", "kama", "qlast", "bola", "bb", "elastic")

dt <- data.frame()

for (m in methods) {

    row <- subset(benchdata, method==m)
    row <- row[c("bitrate", "change", "method")]

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

plt <- plt + ggtitle("all profiles and samples")
print(plt)

cat(paste("The file", filename,"is successfully generated.\n"))
