#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)

df <- read.table("30-60-extended.log", header = FALSE)


x<-df[4];
y<-df[3];
z<-df[1];
u<-df[2];
v<-df[6];
ineff<-df[5];
a <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
b <- matrix(c(" "," "," "," ", " "," "," "," "," "), ncol=1)
e <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
InEFF <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)

for(j in 0:27)
{

for (i in 1:9)
{
  a[i]<-x[i+j*9,]
  b[i]<-paste(y[i+j*9,])
  e[i]<-v[i+j*9,]
  InEFF[i]<-(5*ineff[i+j*9,])  
  c<-paste(z[i+j*9,],u[i+j*9,],"Average Bitrate")
  d<-paste(z[i+j*9,],u[i+j*9,],"# Quality Changes")
  }
xl<-paste("Bitrate (in Kbps)");
yl<-paste("# Change in Quality");
  ss<-trellis.par.get("superpose.symbol")
 ss$pch=rep(19,9)
 ss$col=rainbow(9)
 trellis.par.set(superpose.symbol=ss) 
 p=xyplot(e~a, main = paste(toupper(z[i+j*9,]),toupper(u[i+j*9,])," Buffer: 30/60"), data=data.frame(e,a), pch=20, xlab=xl,ylab=yl, group=b, cex=(InEFF),  scales=list(cex=c(1,1), alternating=1),  key = simpleKey(toupper(b), space = "right"))
 
 #direct.label(p,smart.grid,FALSE)
 #resizePanels()
#print(direct.label(p,smart.grid,FALSE));
print(p);


}


