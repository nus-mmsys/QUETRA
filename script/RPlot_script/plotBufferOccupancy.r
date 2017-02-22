#!/usr/bin/Rscript


args = commandArgs(trailingOnly=TRUE)


df  <- read.csv(args[1], header = TRUE)
c<-"pdf"
d<-"buff"

#output <- unlist(strsplit(args[1], split='/', fixed=TRUE))[1]
output <-sapply(strsplit(args[1], split='/', fixed=TRUE),tail, 1)
dir <-sapply(strsplit(args[1], split='/', fixed=TRUE),tail, 2)
output <- unlist(strsplit(output, split='.', fixed=TRUE))[1]
output<-substr(output,7,nchar(output))
gFold<-paste(dir,"_Graph",sep="")
fold<-"graph"
fold<-paste(fold,gFold,sep="/")
name<- paste("TH_R",output,sep="-")
name<- paste(fold,name,sep="/")
name<- paste(name,c,sep=".")
name1<-paste("Buffer_Occupancy",output,sep="-")
name1<- paste(fold,name1,sep="/")
name1<- paste(name1,c,sep=".")

x<-df$timeStamp
y<-cbind(df$videoBitrate,df$throughput)







pdf(name1,onefile=TRUE)
#jpeg("name1")
a<-df$timeStamp
b<-df$bufferLength
par(mar=c(5, 5,2 ,2))
matplot(a,b,type='s', xlab="Time (Sec)", ylab="Buffer Occupancy (Sec)",main=output, col=rgb(1,0,0,1), lwd="2", lty=1:1,cex.axis=1.3, ,cex.axis=2, cex.lab=2, xlim=c(0,max(a)+0.1*max(a)),ylim=c(0,max(b)+0.1*max(b)))
#legend("topright", c("Buffer Occupancy"), col=rgb(1,0,0,1), lty=c(1), horiz=TRUE )

dev.off()


