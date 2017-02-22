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






pdf(name,onefile=TRUE)
#jpeg("name")
matplot(x,y,type='s', xlab="Time (Sec)", ylab="MBps",main=output, col=c(rgb(1,0,0,.9),rgb(0,0,1,.3)), lwd="2", lty=1:1, xlim=c(0,max(x)+0.1*max(x)), ylim=c(0,6000))
legend("topright", c("Bitrate","Throughput"), col=c(rgb(1,0,0,.9),rgb(0,0,1,.3)), lty=c(1,1),bty="n", horiz=TRUE )
#legend("topleft", c(as.expression(paste("Total quality change:",round(sumR,2)))), col=c(rgb(1,0,0,1)),bty="n" )

dev.off()



