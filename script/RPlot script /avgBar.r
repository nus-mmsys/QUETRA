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

if (length(args) < 3) {
  cat("\nusage: avgBar.r <metric > <output file name>  <Data csv file name>\n")
  cat("       metrics: bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow\n\n")
  quit()
}

metricx <- args[1]


benchdata <- read.csv(args[3], header = TRUE)
filename <- paste(args[2], '.pdf', sep="")

if (! (metricx %in% colnames(benchdata))) {
    cat(paste(metricx,"is not a parameter name\n"))
    quit()
} 



methods <- unique(benchdata[["method"]])
#Modify to filter the method#
#methods <- c("ar", "ra", "quetra", "kama", "gd", "dy")
#
methods <- c("abr", "bba", "quetra", "bola", "elastic")

dt <- data.frame()
for (m in methods) {

    row <- subset(benchdata, method==m)
    row <- row[c(metricx,"method")]

    mean <- colMeans(row[c(metricx)])
    meanrow <- data.frame(metricx=c(mean[metricx]), method=m)
    dt <- rbind(dt, meanrow)
}

pdf(filename,width=20, height=7)

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
 lab<-paste("Buffer Overflow Duration (Sec)");
  } else if (metricx=="numOverflow")
 {
  lab<-paste("Number of Buffer Overflow");
 }





aa<-length(strsplit(paste(dt$method), " "));
Ib <- matrix(nrow=aa, ncol=1);

print(aa)

for(i in 1:aa)
{
 
  if(strsplit(paste(dt$method), " ")[i]=="abr"){
   Ib[i] =paste("Dash.js ABR")
   
  } else if(strsplit(paste(dt$method), " ")[i]=="elastic"){
     Ib[i] =paste("ELASTIC")
  } else if(strsplit(paste(dt$method), " ")[i]=="ar"){
     Ib[i] =paste("Q-Avg Th")
  } else if(strsplit(paste(dt$method), " ")[i]=="bb" | strsplit(paste(dt$method), " ")[i]=="bba"){
     Ib[i] =paste("BBA")
  } else if(strsplit(paste(dt$method), " ")[i]=="dy"){
     Ib[i] =paste("Q-Low EMA")
  } else if(strsplit(paste(dt$method), " ")[i]=="gd"){
     Ib[i] =paste("Q-Gradiant Alpha")
  } else if(strsplit(paste(dt$method), " ")[i]=="kama"){
     Ib[i] =paste("Q-KAMA")
  } else if(strsplit(paste(dt$method), " ")[i]=="quetra"){
     Ib[i] =paste("QUETRA")
  } else if(strsplit(paste(dt$method), " ")[i]=="ra"){
     Ib[i] =paste("Q-Fixed Alpha")
  } else if(strsplit(paste(dt$method), " ")[i]=="bola"){
     Ib[i] =paste("BOLA")
  }
}


#print(dt$metricSize)

dt$method <- as.character(dt$method )
dt$method [dt$method  == "abr"] <- "Dash.js ABR"
dt$method [dt$method  == "elastic"] <- "ELASTIC"
dt$method [dt$method  == "ar"] <- "Q-Avg Th"
dt$method [dt$method  == "bb"] <- "BBA"
dt$method [dt$method  == "bba"] <- "BBA"
dt$method [dt$method  == "dy"] <- "Q-Low EMA"
dt$method [dt$method  == "gd"] <- "Q-Gd Alpha"
dt$method [dt$method  == "kama"] <- "Q-KAMA"
dt$method [dt$method  == "quetra"] <- "QUETRA"
dt$method [dt$method  == "ra"] <- "Q-Fixed Alpha"
dt$method [dt$method  == "bola"] <- "BOLA"

#colnames(dt)[4] <- "Algorithms"
par(mar=c(4,6,4,4))
aa<-barplot(dt$metricx, main="",  width = 7, space =0.8, beside=TRUE, cex.axis=2, cex.lab=2,font = 2, density = 100 ,ylab=list(lab,cex=2.5,font = 2), col=c(160) ,axisnames=dt$metricx, ylim=c(0,max(dt$metricx)+(0.1*max(dt$metricx)))) 
text(x=aa, y=dt$metricx, labels=round(dt$metricx,digits=2), pos=3,xpd=NULL,font = 2, cex=2)
text(labels=dt$method,x=aa, y=0-0.03*max(dt$metricx), pos=1, xpd=TRUE,font = 2, cex=2)




cat(paste("The file", filename,"is successfully generated.\n"))
