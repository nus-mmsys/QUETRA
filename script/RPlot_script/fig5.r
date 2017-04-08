#!/usr/bin/Rscript

#library(ggplot2)

#library(lattice)
#library(directlabels)
#library(latticeExtra)
#require(gridExtra)
#library(stringr)

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
source ('colorRampPaletteAlpha.R')

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  cat("\nusage: avgBar.r <metric > <Data csv file name>\n")
  cat("      programmed for qoe matrics only enter matrics as qoe\n\n")
 quit()
}

metricx <- args[1]

#metricx <- "overflow"



filename <- paste(args[1], '.pdf', sep="")

benchdataI <- read.csv('30-60-qoe.csv', header = TRUE)
benchdataII <- read.csv('120-qoe.csv', header = TRUE)
benchdataIII <- read.csv('240-qoe.csv', header = TRUE)

if (! (metricx %in% colnames(benchdataI))) {
    cat(paste(metricx,"is not a parameter name\n"))
    quit()
} 



methods <- unique(benchdataI[["method"]])
#Modify to filter the method#
#methods <- c("kama", "gd", "dy","ar", "ra", "quetra")
#
methods <- c("abr","bola","elastic","bba","quetra")

dtI <- data.frame()
dtII <- data.frame()
dtIII <- data.frame()

for (m in methods) {

    rowI <- subset(benchdataI, method==m)
    rowI <- rowI[c(metricx,"method")]
    meanI <- colMeans(rowI[c(metricx)])
    meanrowI <- data.frame(metricx=c(meanI[metricx]), method=m)
    dtI <- rbind(dtI, meanrowI)

    rowII <- subset(benchdataII, method==m)
    rowII <- rowII[c(metricx,"method")]
    meanII <- colMeans(rowII[c(metricx)])
    meanrowII <- data.frame(metricx=c(meanII[metricx]), method=m)
    dtII <- rbind(dtII, meanrowII)    

    rowIII <- subset(benchdataIII, method==m)
    rowIII <- rowIII[c(metricx,"method")]
    meanIII <- colMeans(rowIII[c(metricx)])
    meanrowIII <- data.frame(metricx=c(meanIII[metricx]), method=m)
    dtIII <- rbind(dtIII, meanrowIII)  

}

pdf(filename,width=20, height=10)

if (metricx=="bitrate") {
lab<-paste("Bitrate (Kbps)");
} else if (metricx=="change")
 {
  lab<-paste("# Changes in Quality Level ");
 } else if (metricx=="ineff")
 {
  lab<-paste("Inefficiency");
 } else if (metricx=="stall")
 {
  lab<-paste("Stall Duration (Sec)");
 } else if (metricx=="numStall")
 {
  lab<-paste("Number of Stalls");
 } else if (metricx=="avgStall")
 {
  lab<-paste("Average Stall Duration (Sec)");
 } else if (metricx=="overflow")
 {
 lab<-paste("Buffer Full Duration (Sec)");
  } else if (metricx=="numOverflow")
 {
  lab<-paste("Number of Buffer Overflow");
 } else if (metricx=="qoe")
 {
  lab<-paste("QoE ( x100,000)");
 }







#print(dt$metricSize)
dtI$method <- as.character(dtI$method )
dtI$method [dtI$method  == "abr"] <- "Dash.js ABR"
dtI$method [dtI$method  == "elastic"] <- "ELASTIC"
dtI$method [dtI$method  == "ar"] <- "Q-Avg Th"
dtI$method [dtI$method  == "bb"] <- "BBA"
dtI$method [dtI$method  == "bba"] <- "BBA"
dtI$method [dtI$method  == "dy"] <- "Q-Low Pass EMA"
dtI$method [dtI$method  == "gd"] <- "Q-Gradiant Adaptive EMA"
dtI$method [dtI$method  == "kama"] <- "Q-KAMA"
dtI$method [dtI$method  == "quetra"] <- "Q-Last Throughput"
dtI$method [dtI$method  == "ra"] <- "Q-Fixed Alpha"
dtI$method [dtI$method  == "bola"] <- "BOLA"

dtII$method <- as.character(dtII$method )
dtII$method [dtII$method  == "abr"] <- "Dash.js ABR"
dtII$method [dtII$method  == "elastic"] <- "ELASTIC"
dtII$method [dtII$method  == "ar"] <- "Q-Avg Th"
dtII$method [dtII$method  == "bb"] <- "BBA"
dtII$method [dtII$method  == "bba"] <- "BBA"
dtII$method [dtII$method  == "dy"] <- "Q-Low Pass EMA"
dtII$method [dtII$method  == "gd"] <- "Q-Gradiant Adaptive EMA"
dtII$method [dtII$method  == "kama"] <- "Q-KAMA"
dtII$method [dtII$method  == "quetra"] <- "Q-Last Throughput"
dtII$method [dtII$method  == "ra"] <- "Q-Fixed Alpha"
dtII$method [dtII$method  == "bola"] <- "BOLA"

dtIII$method <- as.character(dtIII$method )
dtIII$method [dtIII$method  == "abr"] <- "Dash.js ABR"
dtIII$method [dtIII$method  == "elastic"] <- "ELASTIC"
dtIII$method [dtIII$method  == "ar"] <- "Q-Avg Th"
dtIII$method [dtIII$method  == "bb"] <- "BBA"
dtIII$method [dtIII$method  == "bba"] <- "BBA"
dtIII$method [dtIII$method  == "dy"] <- "Q-Low Pass EMA"
dtIII$method [dtIII$method  == "gd"] <- "Q-Gradiant Adaptive EMA"
dtIII$method [dtIII$method  == "kama"] <- "Q-KAMA"
dtIII$method [dtIII$method  == "quetra"] <- "Q-Last Throughput"
dtIII$method [dtIII$method  == "ra"] <- "Q-Fixed Alpha"
dtIII$method [dtIII$method  == "bola"] <- "BOLA"




#colnames(dt)[4] <- "Algorithms"

if(FALSE){
par(mar=c(4,6,4,4))
aa<-barplot(dtI$metricx, main="",  width = 7, space =0.8, beside=TRUE, cex.axis=2, cex.lab=2,font = 2, density = 100 ,ylab=list(lab,cex=2.5,font = 2), col=c(160) ,axisnames=dtI$metricx, ylim=c(0,max(dtI$metricx)+(0.1*max(dtI$metricx)))) 
text(x=aa, y=dtI$metricx, labels=round(dtI$metricx,digits=2), pos=3,xpd=NULL,font = 2, cex=2)
text(labels=dtI$method,x=aa, y=0-0.03*max(dtI$metricx), pos=1, xpd=TRUE,font = 2, cex=2)

bb<-barplot(dtII$metricx, main="",  width = 7, space =0.8, beside=TRUE, cex.axis=2, cex.lab=2,font = 2, density = 100 ,ylab=list(lab,cex=2.5,font = 2), col=c(160) ,axisnames=dtII$metricx, ylim=c(0,max(dtII$metricx)+(0.1*max(dtII$metricx)))) 
text(x=aa, y=dtII$metricx, labels=round(dtII$metricx,digits=2), pos=3,xpd=NULL,font = 2, cex=2)
text(labels=dtII$method,x=aa, y=0-0.03*max(dtII$metricx), pos=1, xpd=TRUE,font = 2, cex=2)


cc<-barplot(dtIII$metricx, main="",  width = 7, space =0.8, beside=TRUE, cex.axis=2, cex.lab=2,font = 2, density = 100 ,ylab=list(lab,cex=2.5,font = 2), col=c(160) ,axisnames=dtIII$metricx, ylim=c(0,max(dtIII$metricx)+(0.1*max(dtIII$metricx)))) 
text(x=aa, y=dtIII$metricx, labels=round(dtIII$metricx,digits=2), pos=3,xpd=NULL,font = 2, cex=2)
text(labels=dtIII$method,x=aa, y=0-0.03*max(dtIII$metricx), pos=1, xpd=TRUE,font = 2, cex=2)

}

dat <- cbind(dtI$metricx,dtII$metricx,dtIII$metricx)
colnames(dat) <- c("30/60", "120" ,"240")
#colnames(dat) <- c("a", "b" ,"b")
rownames(dat) <- dtI$method

print(dat)

#rescale <- function(x) (x-min(x))/(max(x) - min(x)) * 100
#dat=as.data.frame(dat)
#dat<-scale(dat)

dat<-dat/100000

print(dat)

par(mar=c(4,8,7.5,2) )

angle1 <- rep(c(45,45,135), length.out=3)
angle2 <- rep(c(45,135,135), length.out=3)
density1 <- seq(6,12,length.out=3)
density2 <- seq(6,12,length.out=3)


#barplot(t(dat), main="",beside=TRUE, col=c("darkblue","red","green"),ylim=c(-3,80),ylab="",cex.names=3,cex.axis=3, angle=angle2, density=density2 ) 
#barplot(t(dat), main="",beside=TRUE,add=TRUE, col=c("darkblue","red","darkgreen"),ylim=c(-3,80),ylab="",cex.names=3,cex.axis=3, angle=angle1, density=density1 ) 


barplot(t(dat), main="",beside=TRUE, col=c("darkblue","red","green"),ylab="", ylim=c(0,5),cex.names=1,cex.axis=1, angle=angle2, density=density2 ) 
barplot(t(dat), main="",beside=TRUE,add=TRUE, col=c("darkblue","red","darkgreen"),ylab="",cex.names=1,cex.axis=1, angle=angle1, density=density1 ) 


title(ylab=lab, line=5, cex.lab=3, font = 1)

par(xpd=TRUE)
legend("topright",legend = c("30/60","120","240"), ncol = 3,  fill =c("darkblue","red","darkgreen"),cex = 3, title="Buffer Capacity (Sec)",  bty = "n",inset=c(0,-0.2),angle=angle1, density=density1)
par(bg="transparent")
legend("topright",legend = c("30/60","120","240"), ncol = 3,  fill =c("darkblue","red","darkgreen"),cex = 3, title="Buffer Capacity (Sec)",  bty = "n",inset=c(0,-0.2),angle=angle2, density=density2)


#text(x=aa, y=dat$metricx, labels=round(dat$metricx,digits=2), pos=3,xpd=NULL,font = 2, cex=2)
#text(labels=dat$method,x=aa, y=0-0.03*max(dat$metricx), pos=1, xpd=TRUE,font = 2, cex=2)



cat(paste("The file", filename,"is successfully generated.\n"))
