#!/usr/bin/Rscript
args = commandArgs(trailingOnly=TRUE)

df <- read.table(args[1], header = FALSE)

x<-df[13];
y<-df[3];
z<-df[1];
u<-df[2];
v<-df[5];
ov<-df[6];
un<-df[7];
tinit<-df[9];
trebuff<-df[10];
Frebuff<-df[11];
a <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
b <- matrix(c(" "," "," "," "," "," "," "," "," "), ncol=1)
e <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
TI <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
TR <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
FR <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
MOS <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
countBitrate<-matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
countEff<-matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
countQc<-matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)

pdf(paste(args,".pdf"))

for(j in 0:27)
{

for (i in 1:9)
{
  a[i]<-x[i+j*9,]
  b[i]<-paste(y[i+j*9,])
  e[i]<-v[i+j*9,]
   if(tinit[i+j*9,]>=0 && tinit[i+j*9,]<=1){  TI[i]<-1}
   if(tinit[i+j*9,]>=1 && tinit[i+j*9,]<=5){  TI[i]<-2}
   if(tinit[i+j*9,]>5){  TI[i]<-3}
   if(trebuff[i+j*9,]>=0 && trebuff[i+j*9,]<=0.02){  TR[i]<-1}
   if(trebuff[i+j*9,]>=0.02 && trebuff[i+j*9,]<=0.15){  TR[i]<-2}
   if(trebuff[i+j*9,]>0.15){  TR[i]<-3}
   if(Frebuff[i+j*9,]>=0 && Frebuff[i+j*9,]<=5){  FR[i]<-1}
   if(Frebuff[i+j*9,]>=5 && Frebuff[i+j*9,]<=10){  FR[i]<-2}
   if(Frebuff[i+j*9,]>10){  FR[i]<-3}
   MOS[i]=4.23-(0.0672*TI[i])-(0.742*TR[i])-(0.106*FR[i]);
   print(paste(tinit[i+j*9,]," ",trebuff[i+j*9,], " ",Frebuff[i+j*9,], MOS[i]));
  l1<-paste("Network profile:",z[i+j*9,], "Sample: ",u[i+j*9,], " Metric: MOS", "\n","Buffer: 30/60 ")
 

}


maxBitrate<-which.min(a)
countBitrate[maxBitrate]<-(countBitrate[maxBitrate]+1)
par(mar=c(4,4,4,0.1))
aa<-barplot(a, width = 5, space =5, beside=TRUE, names.arg = b , main=paste(l1," min: ",b[maxBitrate], "\n"), density = 100 , ylab="Kbps", col=c(160) ,axisnames=a) 
text(x=aa, y=a, labels=a, pos=3,xpd=NA)

}

for (k in 1:9)
{
 print(paste(b[k]," MOS ", countBitrate[k], "\n" ))

}


 

dev.off()
