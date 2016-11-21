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
a <- matrix(c(0,0,0,0), ncol=1)
b <- matrix(c(" "," "," "," "), ncol=1)
e <- matrix(c(0,0,0,0), ncol=1)
over <- matrix(c(0,0,0,0), ncol=1)
under <- matrix(c(0,0,0,0), ncol=1)
number <- matrix(c(0,0,0,0), ncol=1)


for(j in 0:27)
{

for (i in 1:6)
{
  a[i]<-x[i+j*6,]
  b[i]<-paste(y[i+j*6,])
  e[i]<-v[i+j*6,]
  over[i]<-ov[i+j*6,]
  under[i]<-un[i+j*6,]
  number[i]<-num[i+j*6,]
  l1<-paste("Network profile:",z[i+j*6,], ", Sample: ",u[i+j*6,],", Metric: Avg-Bitrate, Buffer:120")
  l2<-paste("Network profile:",z[i+j*6,], ", Sample: ",u[i+j*6,],", Metric: Inefficiency, Buffer:120")
  l3<-paste("Network profile:",z[i+j*6,], ", Sample: ",u[i+j*6,],", Metric: # quality change, Buffer:120")
  l4<-paste("Network profile:",z[i+j*6,], ", Sample: ",u[i+j*6,],", Metric: Buffer undeflow, Buffer:120")

}




par(mar=c(4,4,4,0.1))
aa<-barplot(a, width = 5, space =5, beside=TRUE, names.arg = b , main=l1, density = 100 , ylab="Kbps", col=c(160) ,axisnames=a) 
text(x=aa, y=a, labels=a, pos=3,xpd=NA)


bb<-barplot(e, width = 5, space = 5, beside=TRUE, names.arg = b , main=l2, density = 100 , ylab=" Inefficiency", col=c(160) ) 
text(x=bb, y=e, labels=e, pos=3,xpd=NA)

cc<-barplot(number, width = 5, space = 5, beside=TRUE, names.arg = b , main=l3, density = 100 , ylab="# Quality changes", col=c(160) ) 
text(x=cc, y=number, labels=number, pos=3,xpd=NA)

dd<-barplot(under, width = 5, space = 5, beside=TRUE, names.arg = b , main=l4, density = 100 , ylab="Buffer undeflow duration (sec)", col=c(160) ) 
text(x=dd, y=under, labels=under, pos=3,xpd=NA)

}


