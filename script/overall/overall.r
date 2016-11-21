#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
require(crop)
source ('colorRampPaletteAlpha.R')
Idf <- read.table("30-60-extended.log", header = TRUE)
IIdf <- read.table("120-extended.log", header = TRUE)
IIIdf <- read.table("240-extended.log", header = TRUE)


Idf <- Idf[Idf$method=="bb"|Idf$method=="bola"|Idf$method=="elastic"|Idf$method=="qlast",]
IIdf <- IIdf[IIdf$method=="bb"|IIdf$method=="bola"|IIdf$method=="elastic"|IIdf$method=="qlast",]
IIIdf <- IIIdf[IIIdf$method=="bb"|IIIdf$method=="bola"|IIIdf$method=="elastic"|IIIdf$method=="qlast",]


xl<-paste("Bitrate (in Kbps)");
yl<-paste("# Change in Quality");

trim <- function (x) gsub("^\\s+|\\s+$", "", x);

#postscript(file=paste("new",".eps"));


#width=7,height=5,


 ss<-trellis.par.get("superpose.symbol")
 ss$pch=rep(1,5)
 ss$col=brewer.pal(4, "Paired")
 addalpha(ss$col, 0.1)
  ss$cex=c(0.7,0.7)
 trellis.par.set(superpose.symbol=ss) 

#aggregate(Idf[,4:13], list(Idf$method), mean)
Idf <-aggregate(Idf, by=list(Idf$method),FUN=mean, na.rm=FALSE)

#Idf$change~Idf$avgR,
print(Idf)
Ib <- matrix(c(" "," "," "," "), ncol=1);

Ib[1]<-paste("Nearest-Avg Throughput")

          Ib[2]<-paste("QUETRA-Avg Throughput")
	
	  Ib[3]<-paste("Buffer Based")
	
	  Ib[4]<-paste("BOLA-Last")


xyplot(Idf$change~Idf$avgR, main = paste("\n         Buffer: 30/60"), data=Idf, pch=1, xlab=" ", ylab=yl, col=brewer.pal(4, "Dark2"), font.lab=2, cex=(7*Idf$ineff),  scales=list(cex=c(0.7,0.7)),ylim=c(-20, max(Idf$change)+30),xlim=c(min(Idf$avgR)-250, max(Idf$avgR)+250) )

#print(Idf$change)
##print(Idf$avgR)
#print(Idf$ineff)

#xyplot(Idf$change~Idf$avgR)

 
dev.off()



