#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
require(crop)
library(RColorBrewer)
#library(ggplot2)
source ('colorRampPaletteAlpha.R')


args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 2) {
  cat("\nusage: evaluate-avgm.r <metric> <benchmark file name>\n")
  cat("       metrics: bitrate, change, stall, numStall, avgStall\n\n")
  quit()
}

metricx <- args[1]
#metricy <- args[2]


benchdata <- read.csv(args[2], header = TRUE)
filename <- paste(args[2], '-q-vs-all-stall.pdf', sep="")

if (! (metricx %in% colnames(benchdata))) {
    cat(paste(metricx,"is not a column name\n"))
    quit()
} 


methods <- unique(benchdata[["method"]])
#methods <- c("ar", "ra", "quetra", "kama", "gd", "dy")
methods <- c("abr", "bb", "quetra", "bola", "elastic")

dt <- data.frame()
for (m in methods) {

    row <- subset(benchdata, method==m)
    row <- row[c(metricx, "method")]

    mean <- colMeans(row[c(metricx)])
    meanrow <- data.frame(metricx=c(round(mean[metricx],digits = 2)),method=m)
    dt <- rbind(dt, meanrow)
}

pdf(filename)

if (metricx=="bitrate") {
ylab<-paste("Bitrate (Kbps)");
} else if (metricx=="change")
 {
  ylab<-paste("# Quality Level Change");
 } else if (metricx=="ineff")
 {
  ylab<-paste("Inefficiency");
 } else if (metricx=="stall")
 {
  ylab<-paste("Stall Duration (Sec)");
 } else if (metricx=="numStall")
 {
  ylab<-paste("Number of Stalls");
 } else if (metricx=="avgStall")
 {
  ylab<-paste("Average Stall Duration (Sec)");
 } else if (metricx=="overflow")
 {
 ylab<-paste("Buffer Overflow Duration (Sec)");
  } else if (metricx=="numOverflow")
 {
  ylab<-paste("Number of Buffer Overflow");
 }



#plt <- ggplot()
#plt <- plt + geom_point(data=dt,
#                       aes(x=metricx,
#                           y=metricy,
#                           color=method))

#plt <- plt + xlab(metricx) + ylab(metricy)
#plt <- plt + ggtitle("all profiles and samples")
#print(plt)


Ib <- matrix(c(" "," "," "," "," "," "), ncol=1);


aa<-length(strsplit(paste(dt$method), " "));

print(aa)

for(i in 1:aa)
{
  print(i)
  if(strsplit(paste(dt$method), " ")[i]=="abr"){
   Ib[i] =paste("            ABR")
   
  } else if(strsplit(paste(dt$method), " ")[i]=="elastic"){
     Ib[i] =paste("     ELASTIC")
  } else if(strsplit(paste(dt$method), " ")[i]=="ar"){
     Ib[i] =paste("  Avg Throughput")
  } else if(strsplit(paste(dt$method), " ")[i]=="bb"){
     Ib[i] =paste("            BBA")
  } else if(strsplit(paste(dt$method), " ")[i]=="dy"){
     Ib[i] =paste("    Low pass EMA")
  } else if(strsplit(paste(dt$method), " ")[i]=="gd"){
     Ib[i] =paste("    Gradiant Alpha")
  } else if(strsplit(paste(dt$method), " ")[i]=="kama"){
     Ib[i] =paste("                  KAMA")
  } else if(strsplit(paste(dt$method), " ")[i]=="quetra"){
     Ib[i] =paste("     QUETRA")
  } else if(strsplit(paste(dt$method), " ")[i]=="ra"){
     Ib[i] =paste("        Fixed Alpha")
  } else if(strsplit(paste(dt$method), " ")[i]=="bola"){
     Ib[i] =paste("          BOLA")
  }
}

print( Ib[,1])

 par(mar=c(13, 5 ,1 ,3))

 


aa<-barplot(dt$metricx, width = 35, space =1.75, beside=TRUE, density = 20 , ylab=" Average Number of Stalls ", cex.axis=2, cex.lab=2,axisnames=dt$metricx, ylim=c(0,4)) 
text(labels=Ib,x=aa-3, y=-1.2, srt=90, pos=1, xpd=TRUE, cex=1.8)
#text(x=aa, y=Ia, labels=round(Ia, digits = 2), pos=3,xpd=NA)
#text(labels=Ib,x=aa, y=0, srt=45, pos=1, xpd=TRUE)


#xyplot(dt$metricx~dt$metricy,xlab=xlab, ylab=ylab,   )


cat(paste("The file", filename,"is successfully generated.\n"))
