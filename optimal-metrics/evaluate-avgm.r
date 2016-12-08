#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 3) {
  cat("\nusage: evaluate-avgm.r <metric x> <metric y> <benchmark file name>\n")
  cat("       metrics: bitrate, change, stall, numStall, avgStall\n\n")
  quit()
}

metricx <- args[1]
metricy <- args[2]

benchdata <- read.csv(args[3], header = TRUE)
filename <- paste(args[3], '-avgm.pdf', sep="")

if (! (metricx %in% colnames(benchdata))) {
    cat(paste(metricx,"is not a column name\n"))
    quit()
} 

if (! (metricy %in% colnames(benchdata))) {
    cat(paste(metricy,"is not a column name\n"))
    quit()
} 

pdf(filename)

methods <- unique(benchdata[["method"]])
#methods <- c("gd", "kama", "qlast", "bola", "bb", "elastic")


dt <- data.frame()

for (m in methods) {

    row <- subset(benchdata, method==m)
    row <- row[c(metricx, metricy, "method")]

    mean <- colMeans(row[c(metricx, metricy)])
    meanrow <- data.frame(metricx=c(mean[metricx]),
                              metricy=c(mean[metricy]),
                              method=m)
    dt <- rbind(dt, meanrow)
}
#print(dt)
plt <- ggplot()
plt <- plt + geom_point(data=dt,
                       aes(x=metricx,
                           y=metricy,
                           color=method))

plt <- plt + xlab(metricx) + ylab(metricy)
plt <- plt + ggtitle("all profiles and samples")
print(plt)

cat(paste("The file", filename,"is successfully generated.\n"))
