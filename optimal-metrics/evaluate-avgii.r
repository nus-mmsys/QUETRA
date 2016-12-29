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
#benchdata <- benchdata[benchdata$method=="bb"|benchdata$method=="bola"|benchdata$method=="elastic"|benchdata$method=="qlast",]

filename <- paste(args[2], '.pdf', sep="")
pdf(filename)

for (p in networkprof) {
    
    optmean <- data.frame()

    # Uncomment for adding optimum
    #optsum = data.frame()
    #for (p in networkprof) {
    #    optdata <- read.csv(paste(args[1], "/", p, "-", t, ".csv", sep=""))
    #    optdata <- optdata[c("bitrate", "change")]
    #    optsum <- rbind(optsum, optdata)
    #}
    #mean <- colMeans(optsum)
    #optmean <- data.frame(bitrate=c(mean["bitrate"]),
    #                      change=c(mean["change"]), 
    #                      method=c("optimum"))

    benchsum <- subset(benchdata, profile==p)
    benchsum <- benchsum[c("bitrate", "change", "ineff","stall","numStall","method")]

    dt <- optmean
    methods <- unique(benchsum["method"])
    for(i in 1:nrow(methods)) {
        m <- methods[i,][1]
        row <- subset(benchsum, method==m)
        mean <- colMeans(row[c("bitrate", "change", "ineff","stall","numStall")])
        meanrow <- data.frame(bitrate=c(mean["bitrate"]),
                              change=c(mean["change"]),
                              ineff=c(mean["ineff"]),
			      stall=c(mean["stall"]),
                              numStall=c(mean["numStall"]),
                              method=m)
        dt <- rbind(dt, meanrow)
    }
     cc<-barplot(dt$bitrate, width = 5, space = 5, beside=TRUE, main=paste("Profile ",p, sep=""," Avergae Bitrate"), name.arg=dt$method,density = 100 , ylab="Kbps", col=c(160) ) 
     text(x=cc, y=dt$bitrate, labels=round(dt$bitrate, digits = 2), pos=3,xpd=NA)
     text(cex=1, x=cc+2.5, y=0, dt$method, xpd=TRUE, srt=45, pos=2)
   
     aa<-barplot(dt$change, width = 5, space = 5, beside=TRUE, main=paste("Profile ",p, sep=""," Quality Change"), name.arg=dt$method,density = 100 , ylab="#", col=c(160) ) 
     text(x=aa, y=dt$change, labels=round(dt$change, digits = 2), pos=3,xpd=NA)
     text(cex=1, x=aa+2.5, y=0, dt$method, xpd=TRUE, srt=45, pos=2)

     bb<-barplot(dt$ineff, width = 5, space = 5, beside=TRUE, main=paste("Profile ",p, sep=""," Inefficiency"), name.arg=dt$method,density = 100 , ylab="Inefficiency", col=c(160) ) 
     text(x=bb, y=dt$ineff, labels=round(dt$ineff, digits = 2), pos=3,xpd=NA)
     text(cex=1, x=bb+2.5, y=0, dt$method, xpd=TRUE, srt=45, pos=2)

     dd<-barplot(dt$stall, width = 5, space = 5, beside=TRUE, main=paste("Profile ",p, sep=""," Stall Duration"), name.arg=dt$method,density = 100 , ylab="Sec", col=c(160) ) 
     text(x=dd, y=dt$stall, labels=round(dt$stall, digits = 2), pos=3,xpd=NA)
     text(cex=1, x=dd+2.5, y=0, dt$method, xpd=TRUE, srt=45, pos=2)

     ee<-barplot(dt$numStall, width = 5, space = 5, beside=TRUE, main=paste("Profile ",p, sep=""," # Stalls"), name.arg=dt$method,density = 100 , ylab="#", col=c(160) ) 
     text(x=ee, y=dt$numStall, labels=round(dt$numStall, digits = 2), pos=3,xpd=NA)
     text(cex=1, x=ee+2.5, y=0, dt$method, xpd=TRUE, srt=45, pos=2)

}

cat(paste("The file", filename,"is successfully generated.\n"))
