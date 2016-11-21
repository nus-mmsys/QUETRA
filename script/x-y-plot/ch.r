#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
require(crop)

Idf <- read.table("30-60-extended.log", header = FALSE)



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







for(j in 0:27)
{

for (i in 1:9)
{
  Ia[i]<-Ix[i+j*9,]
  Ib[i]<-paste(Iy[i+j*9,])
  Ie[i]<-Iv[i+j*9,]
  IinEFF[i]<-(5*Iineff[i+j*9,])  


 


}
xl<-paste("Bitrate (in Kbps)");
yl<-paste("# Change in Quality");

postscript(file=paste(toupper(Iz[i+j*9,]),toupper(Iu[i+j*9,]),".eps"),onefile=FALSE, horizontal=FALSE,paper="special",width=12,height=4);

#width=7,height=5,


 ss<-trellis.par.get("superpose.symbol")
 ss$pch=rep(19,9)
ss$col=rainbow(9)
 ss$cex=c(0.7,0.7)
trellis.par.set(superpose.symbol=ss) 

 Ip<-barplot(Ia, width = 5, space =5, beside=TRUE,col=rainbow(9)) 

legend(x = "top",inset = 0,
        legend = toupper(Ib), 
        col=rainbow(9), lwd=3, cex=.5, horiz = FALSE)

dev.off.crop(file=paste(toupper(Iz[i+j*9,]),toupper(Iu[i+j*9,]),".eps"))
}


