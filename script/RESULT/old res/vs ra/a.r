#!/usr/bin/Rscript
args = commandArgs(trailingOnly=TRUE)

df <- read.table(args[1], header = FALSE)

x<-df[4];
y<-df[3];
z<-df[1];
u<-df[2];
v<-df[5];
ov<-df[6];
un<-df[7];
num<-df[8];
a <- matrix(c(0,0,0,0,0), ncol=1)
b <- matrix(c(" "," "," "," "," "), ncol=1)
e <- matrix(c(0,0,0,0,0), ncol=1)
over <- matrix(c(0,0,0,0,0), ncol=1)
under <- matrix(c(0,0,0,0,0), ncol=1)
number <- matrix(c(0,0,0,0,0), ncol=1)
countBitrate<-matrix(c(0,0,0,0,0), ncol=1)
countEff<-matrix(c(0,0,0,0,0), ncol=1)
countQc<-matrix(c(0,0,0,0,0), ncol=1)

pdf(paste(args,".pdf"))

for(j in 0:27)
{

for (i in 1:5)
{
  a[i]<-x[i+j*5,]
  b[i]<-paste(y[i+j*5,])
  e[i]<-v[i+j*5,]
  over[i]<-ov[i+j*5,]
  under[i]<-un[i+j*5,]
  number[i]<-num[i+j*5,]
  l1<-paste("Network profile:",z[i+j*5,], "Sample: ",u[i+j*5,], " Metric: Avg-Bitrate", "\n","Buffer: 30-60 ")
  l2<-paste("Network profile:",z[i+j*5,], "Sample: ",u[i+j*5,],"Metric: Inefficiency", " \n ","Buffer: 30-60 ")
  l3<-paste("Network profile:",z[i+j*5,], "Sample: ",u[i+j*5,],"Metric: # quality change", "\n","Buffer: 30-60 ")

}


maxBitrate<-which.max(a)
countBitrate[maxBitrate]<-(countBitrate[maxBitrate]+1)
par(mar=c(4,4,4,0.1))
aa<-barplot(a, width = 5, space =5, beside=TRUE, names.arg = b , main=paste(l1," max: ",b[maxBitrate], "\n"), density = 100 , ylab="Kbps", col=c(160) ,axisnames=a) 
text(x=aa, y=a, labels=a, pos=3,xpd=NA)

minEff<-which.min(e)
countEff[minEff]<-(countEff[minEff]+1)
bb<-barplot(e, width = 5, space = 5, beside=TRUE, names.arg = b , main=paste(l2," min: ",b[minEff], "\n"), density = 100 , ylab=" Inefficiency", col=c(160) ) 
text(x=bb, y=e, labels=e, pos=3,xpd=NA)

minCh<-which.min(number)
countQc[minCh]<-(countQc[minCh]+1)
cc<-barplot(number, width = 5, space = 5, beside=TRUE, names.arg = b , main=paste(l3," min: ",b[minCh], "\n"), density = 100 , ylab="# Quality changes", col=c(160) ) 
text(x=cc, y=number, labels=number, pos=3,xpd=NA)


}

for (k in 1:5)
{
 print(paste(b[k]," Bitrate ", countBitrate[k], " Inefficieny ", countEff[k], " # change ", countQc[k], "\n" ))

}


 

dev.off()
