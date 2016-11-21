#!/usr/bin/Rscript

library(lattice)
library(directlabels)

df <- read.table("result.log", header = FALSE)
x<-df[4];
y<-df[3];
z<-df[1];
u<-df[2];
v<-df[5];
a <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
b <- matrix(c(" "," "," "," "," "," "," "," "," "), ncol=1)
e <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)


j<-0;

while (j<21)
{
 for (i in 1:9)
{
  a[i]<-x[i+j*9,]
  b[i]<-paste(y[i+j*9,])
  e[i]<-v[i+j*9,]
  c<-paste(z[i+j*9,],u[i+j*9,])
  d<-paste(z[i+j*9,],u[i+j*9,],"# R changes")
}

xl<-paste("Bitrate (in Kbps)");
yl<-paste("Inefficiency");
 
 p=xyplot(e~a, main = c, data=data.frame(e,a), pch=20, xlab=xl,ylab=yl, group=b, cex=1:4)
 direct.label(p,smart.grid,FALSE)
 
print(direct.label(p,smart.grid,FALSE));
j<-j+1;

}







