#!/usr/bin/Rscript


args = commandArgs(trailingOnly=TRUE)
df1  <- read.csv(args[1], header = TRUE)
df2  <- read.csv(args[2], header = TRUE)
df3  <- read.csv(args[3], header = TRUE)
df<-df1
name1 = "bufferOccupancyCombined.pdf"
pdf(name1,onefile=TRUE)
a<-df$timeStamp
b<-df$bufferLength
par(mar=c(5, 5,2 ,2))
matplot(a,b,type='l', xlab="Time (Sec)", ylab="Buffer Occupancy (Sec)",main="", col="red", yaxt='n',xaxt='n',lwd="2", lty=1,cex.axis=1.3, ,cex.axis=2, cex.lab=2, xlim=c(0,600), ylim=c(0,150))
par(new=TRUE)
df<-df2
a<-df$timeStamp
b<-df$bufferLength
matplot(a,b,type='l',xlim=c(0,600), ylim=c(0,150),xlab=" ",ylab= " ", col="darkblue",lwd="2", lty=1,axes=FALSE)
par(new=TRUE)
df<-df3
a<-df$timeStamp
b<-df$bufferLength
matplot(a,b,type='l',xlim=c(0,600), ylim=c(0,150),xlab=" ",ylab= " ", col="green4",lwd="2", lty=1,axes=FALSE)
axis(2, at=c(0,30,60,90,120),labels=c(0,30,60,90,120), col.axis="black", las=0,cex.axis=2,lty=2,tck=-0.01,lwd.ticks="2" )
axis(1, at=c(0,150,300,450,600),labels=c(0,150,300,450,600), col.axis="black", las=0,cex.axis=2,lty=2,tck=-0.01,lwd.ticks="2" )
legend("topright", c("30 Sec","120 Sec", "240 Sec"), title="Buffer Capacity", col=c( "red","darkblue","green4"), lty=1,lwd="3", bty="n", horiz=TRUE, cex=1.4)
dev.off()


