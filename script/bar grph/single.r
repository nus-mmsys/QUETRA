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
comm<-matrix(c(0,0,0,0,0), ncol=1)
countBitrate<-matrix(c(0,0,0,0,0), ncol=1)
index<-matrix(c(1,3,4,6,9), ncol=1)

pdf(paste("overall",args,".pdf"))

for(j in 0:27)
{

for (i in 1:5)
{
  a[i]<-x[index[i]+j*9,]
  b[i]<-paste(y[index[i]+j*9,])
  e[i]<-v[index[i]+j*9,]
  over[i]<-ov[index[i]+j*9,]
  under[i]<-un[index[i]+j*9,]
  number[i]<-num[index[i]+j*9,]
  
  l1<-paste("Network profile:",z[i+j*9,], "Sample: ",u[i+j*9,], " Metric: Overall", "\n","Buffer: 30/60 ")

}


 
for( k in 1:5)
{
 comm[k]<-(a[k]/max(a))+(1-e[k])+(1-(number[k]/max(k)))
}

maxBitrate<-which.max(comm)
countBitrate[maxBitrate]<-(countBitrate[maxBitrate]+1)

par(mar=c(4,4,4,0.1))
aa<-barplot(comm, width = 5, space =5, beside=TRUE, names.arg = b , main=paste(l1," max: ",b[maxBitrate], "\n"), density = 100 , ylab="Kbps", col=c(160) ,axisnames=a) 
text(x=aa, y=comm, labels=comm, pos=3,xpd=NA)


}


for (l in 1:5)
{
 print(paste(b[l]," Overall ", countBitrate[l], "\n" ))

}
 

dev.off()
