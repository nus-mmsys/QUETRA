#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)

Idf <- read.table("30-60-extended.log", header = FALSE)
IIdf <- read.table("120-extended.log", header = FALSE)
IIIdf <- read.table("240-extendedresult.log", header = FALSE)


Iz<-Idf[1];
Iu<-Idf[2];
Iy<-Idf[3];
Iv<-Idf[8];
Ix<-Idf[4];
Iineff<-Idf[5];
Ia <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
Ib <- matrix(c(" "," "," "," ", " "," "," "," "," "), ncol=1)
Ie <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
IinEFF <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)



IIz<-IIdf[1];
IIu<-IIdf[2];
IIy<-IIdf[3];
IIv<-IIdf[8];
IIx<-IIdf[4];
IIineff<-IIdf[5];
IIa <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
IIb <- matrix(c(" "," "," "," ", " "," "," "," "," "), ncol=1)
IIe <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
IIinEFF <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)

da<-0;
db<-0;



IIIz<-IIIdf[1];
IIIu<-IIIdf[2];
IIIy<-IIIdf[3];
IIIv<-IIIdf[8];
IIIx<-IIIdf[4];
IIIineff<-IIIdf[5];
IIIa <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
IIIb <- matrix(c(" "," "," "," ", " "," "," "," "," "), ncol=1)
IIIe <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)
IIIinEFF <- matrix(c(0,0,0,0,0,0,0,0,0), ncol=1)





for(j in 0:27)
{

for (i in 1:9)
{
  Ia[i]<-Ix[i+j*9,]
  Ib[i]<-paste(Iy[i+j*9,])
  Ie[i]<-Iv[i+j*9,]
  IinEFF[i]<-(5*Iineff[i+j*9,])  



  IIa[i]<-IIx[i+j*9,]
  IIb[i]<-paste(IIy[i+j*9,])
  IIe[i]<-IIv[i+j*9,]
  IIinEFF[i]<-(5*IIineff[i+j*9,]) 


  IIIa[i]<-IIIx[i+j*9,]
  IIIb[i]<-paste(IIIy[i+j*9,])
  IIIe[i]<-IIIv[i+j*9,]
  IIIinEFF[i]<-(5*IIIineff[i+j*9,]) 


}
xl<-paste("Bitrate (in Kbps)");
yl<-paste("# Change in Quality");

Cx<-union(Ia,IIa)
Cx<-union(Cx,IIa)
Cy<-union(Ie,IIe)
Cy<-union(Cy,IIIe)

 ss<-trellis.par.get("superpose.symbol")
 ss$pch=rep(19,9)
 ss$col=rainbow(9)
  ss$cex=c(0.7,0.7)
 trellis.par.set(superpose.symbol=ss) 

 Ip=xyplot(Ie~Ia, main = paste("\nBuffer: 30/60"), data=data.frame(Ie,Ia), pch=20, xlab=" ", ylab=yl, group=Ib, cex=(IinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(min(Cy), max(Cy)),xlim=c(min(Cx), max(Cx)) )

 IIp=xyplot(IIe~IIa, main = paste(toupper(IIz[i+j*9,]),toupper(IIu[i+j*9,]),"\n","Buffer: 120"), data=data.frame(IIe,IIa), pch=20, xlab=xl, ylab=NULL,group=IIb, cex=(IIinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(min(Cy), max(Cy)),xlim=c(min(Cx), max(Cx)))


 IIIp=xyplot(IIIe~IIIa, main = paste("\nBuffer: 240"), data=data.frame(IIIe,IIIa), pch=20, xlab=" ", ylab=NULL,group=IIIb, cex=(IIIinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(min(Cy), max(Cy)),xlim=c(min(Cx), max(Cx)))


It=xyplot(da~db, group=IIIb,  key = simpleKey(toupper(IIIb), space = "left",cex=c(0.7,0.7)),ylab=NULL,xlab=NULL, par.settings = list(axis.line = list(col = 0)),scales=list(cex=c(0.1,0.1),x=list(at=NULL),y=list(at=NULL)))


 #,  key = simpleKey(toupper(IIb), space = "right")




grid.arrange(Ip,IIp,IIIp,It,ncol=4,heights=c(4,4),widths=c(5,5,5,2))

}


