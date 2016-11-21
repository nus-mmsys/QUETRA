#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
require(crop)
source ('colorRampPaletteAlpha.R')
Idf <- read.table("30-60-extended.log", header = FALSE)
IIdf <- read.table("120-extended.log", header = FALSE)
IIIdf <- read.table("240-extended.log", header = FALSE)


Iz<-Idf[1];
Iu<-Idf[2];
Iy<-Idf[3];
Iv<-Idf[8];
Ix<-Idf[4];
Iineff<-Idf[5];
Ia <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
Ib <- matrix(c(" "," "," "," ", " "," "," "," "," ", " "), ncol=1)
Ie <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IinEFF <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)



IIz<-IIdf[1];
IIu<-IIdf[2];
IIy<-IIdf[3];
IIv<-IIdf[8];
IIx<-IIdf[4];
IIineff<-IIdf[5];
IIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIb <- matrix(c(" "," "," "," ", " "," "," "," "," ", " "), ncol=1)
IIe <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIinEFF <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)

da<-0;
db<-0;



IIIz<-IIIdf[1];
IIIu<-IIIdf[2];
IIIy<-IIIdf[3];
IIIv<-IIIdf[8];
IIIx<-IIIdf[4];
IIIineff<-IIIdf[5];
IIIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIIb <- matrix(c(" "," "," "," ", " "," "," "," "," ", " "), ncol=1)
IIIe <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIIinEFF <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)





for(j in 0:27)
{

for (i in 1:10)
{
  Ia[i]<-Ix[i+j*10,]
 # Ib[i]<-paste(Iy[i+j*9,])
  Ie[i]<-Iv[i+j*10,]
  IinEFF[i]<-(Iineff[i+j*10,])  
  






  IIa[i]<-IIx[i+j*10,]
 #IIb[i]<-paste(IIy[i+j*9,])
  IIe[i]<-IIv[i+j*10,]
  IIinEFF[i]<-(7*IIineff[i+j*10,]) 


  IIIa[i]<-IIIx[i+j*10,]
 #IIIb[i]<-paste(IIIy[i+j*9,])
  IIIe[i]<-IIIv[i+j*10,]
  IIIinEFF[i]<-(IIIineff[i+j*10,]) 


      
	
	
	
	


       
	
	

}




          Ib[1]<-paste("QUETRA-Avg Throughput")
	
	  Ib[2]<-paste("Buffer Based")
	
	  Ib[3]<-paste("BOLA-Last")
	
	
	  Ib[4]<-paste("ELASTIC-Last")
	
	  Ib[5]<-paste("QUETRA-Last")





xl<-paste("Bitrate (in Kbps)");
yl<-paste("# Change in Quality");

trim <- function (x) gsub("^\\s+|\\s+$", "", x);

postscript(file=str_replace_all(paste(trimws(toupper(IIz[i+j*5,])),trimws(toupper(IIu[i+j*5,])),".eps"), fixed(" "), ""),onefile=FALSE, horizontal=FALSE,paper="special",width=12,height=4);

#width=7,height=5,
Cx<-union(Ia,IIa)
Cx<-union(Cx,IIa)
Cy<-union(Ie,IIe)
Cy<-union(Cy,IIIe)

 ss<-trellis.par.get("superpose.symbol")
 ss$pch=rep(1,5)
 ss$col=brewer.pal(5, "Dark2")
 addalpha(ss$col, 0.1)
  ss$cex=c(0.7,0.7)
 trellis.par.set(superpose.symbol=ss) 

 Ip=xyplot(Ie~Ia, main = paste("\n         Buffer: 30/60"), data=data.frame(Ie,Ia), pch=1, xlab=" ", ylab=yl,  font.lab=2,group=IIIb, cex=(IinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(-20, max(Cy)+37),xlim=c(min(Cx)-250, max(Cx)+260) )

 IIp=xyplot(IIe~IIa, main = paste("    Profile:",toupper(substr(IIz[i+j*5,],2,2)),",  Sample:",toupper(substr(IIu[i+j*5,],2,2)),"\n","    Buffer: 120"), data=data.frame(IIe,IIa), pch=1, xlab=xl, ylab=NULL, font.lab=2,group=IIIb, cex=(IIinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(-20, max(Cy)+37),xlim=c(min(Cx)-250, max(Cx)+260))



my.settings <- list(
  par.main.text = list(font = 2, # make it bold
                       just = "left", 
                       x = grid::unit(5, "mm")))



 IIIp=xyplot(IIIe~IIIa, par.settings=my.settings,main = paste("\n                       Buffer: 240"),  data=data.frame(IIIe,IIIa), pch=1,key = simpleKey(sort(IIIb),space="right",cex=c(0.75,0.75)), xlab=" ", ylab=NULL,group=IIIb, cex=(IIIinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(-20, max(Cy)+37),xlim=c(min(Cx)-250, max(Cx)+260))


#It=xyplot(1~1 group=IIIb,  key = simpleKey(toupper(IIIb), corner = c(-0.5,0.5),cex=c(0.7,0.7)),ylab=NULL,xlab=NULL, par.settings = list(axis.line = list(col = 0)),scales=list(cex=c(0.1,0.1),x=list(at=NULL),y=list(at=NULL)))
#It=  key = simpleKey(toupper(IIb), space = "right")

#,heights=c(4),widths=c(5,5,5,3)

#It,
grid.arrange(Ip,IIp,IIIp, ncol=3,widths=c(2,2,3.25))
#dev.off()

dev.off.crop(file=str_replace_all(paste(trimws(toupper(IIz[i+j*5,])),trimws(toupper(IIu[i+j*5,])),".eps"),fixed(" "), ""))
}


