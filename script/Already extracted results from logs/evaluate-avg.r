#!/usr/bin/Rscript


library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
require(crop)
source ('colorRampPaletteAlpha.R')
args <- commandArgs(trailingOnly=TRUE)

Ib <- matrix(c(" "," "," "," "), ncol=1)
networkprof <- c("p1", "p2", "p3", "p4")
videoprof <- c("t1", "t2", "t3", "t4", "t5", "t6", "t7")

benchdata <- read.csv(args[1], header = TRUE)

filename <- paste(args[1], '.pdf', sep="")
pdf(filename)

for (p in networkprof) {

for (t in videoprof) {
   
    benchsum <- subset(benchdata, profile==p)
    benchsum <- subset(benchsum, sample==t)

     Idf<-benchsum;

      mm1<-paste(Idf$profile," ",Idf$sample," Avergae Bitrate \n")
      mm2<-paste(Idf$profile," ",Idf$sample," Quality Change \n")
      mm3<-paste(Idf$profile," ",Idf$sample," Inefficiency \n")
      mm4<-paste(Idf$profile," ",Idf$sample," Total Stall \n")
      mm5<-paste(Idf$profile," ",Idf$sample," Number of Stall \n")
      mm6<-paste(Idf$profile," ",Idf$sample," Average Stall \n")
      mm7<-paste(Idf$profile," ",Idf$sample," Buffer Overflow \n")
      mm8<-paste(Idf$profile," ",Idf$sample," Number of Buffer Overflow \n")



par(mar=c(4,4,4,0.1))
aa<-barplot(Idf$bitrate, main=mm1[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="Kbps", col=c(160) ,axisnames=Idf$bitrate, ylim=c(0,max(Idf$bitrate)+500)) 
text(x=aa, y=Idf$bitrate, labels=Idf$bitrate, pos=3,xpd=NULL)

bb<-barplot(Idf$change, main=mm2[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="Change", col=c(160) ,axisnames=Idf$change, ylim=c(0,max(Idf$change)+20)) 
text(x=bb, y=Idf$change, labels=Idf$change, pos=3,xpd=NULL)

cc<-barplot(Idf$ineff, main=mm3[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="Inefficiency", col=c(160) ,axisnames=Idf$ineff, ylim=c(0,1)) 
text(x=cc, y=Idf$ineff, labels=Idf$ineff, pos=3,xpd=NULL)

dd<-barplot(Idf$stall, main=mm4[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="Sec", col=c(160) ,axisnames=Idf$stall, ylim=c(0,max(Idf$stall)+20)) 
text(x=dd, y=Idf$stall, labels=Idf$stall, pos=3,xpd=NULL)

ee<-barplot(Idf$numStall, main=mm5[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="#", col=c(160) ,axisnames=Idf$numStall, ylim=c(0,max(Idf$numStall)+20)) 
text(x=ee, y=Idf$numStall, labels=Idf$numStall, pos=3,xpd=NULL)

ff<-barplot(Idf$avgStall, main=mm6[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="Sec", col=c(160) ,axisnames=Idf$avgStall, ylim=c(0,max(Idf$avgStall)+5)) 
text(x=ff, y=Idf$avgStall, labels=Idf$avgStall, pos=3,xpd=NULL)

gg<-barplot(Idf$overflow, main=mm7[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="Sec", col=c(160) ,axisnames=Idf$overflow, ylim=c(0,max(Idf$overflow)+20)) 
text(x=gg, y=Idf$overflow, labels=Idf$overflow, pos=3,xpd=NULL)

hh<-barplot(Idf$numOverflow, main=mm8[1],  width = 5, space =5, beside=TRUE, names.arg = Idf$method,  density = 100 , ylab="#", col=c(160) ,axisnames=Idf$numOverflow, ylim=c(0,max(Idf$numOverflow)+20)) 
text(x=hh, y=Idf$numOverflow, labels=Idf$numOverflow, pos=3,xpd=NULL)

#
}

}


#


cat(paste("The file", filename,"is successfully generated.\n"))
