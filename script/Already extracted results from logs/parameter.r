#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
require(crop)
source ('colorRampPaletteAlpha.R')
Idf <- read.table("30-60-result-hl.log", header = FALSE)
IIdf <- read.table("120-result-hl.log", header = FALSE)
IIIdf <- read.table("240-result-hl.log", header = FALSE)

#############################################
# Update file name for parameter Ylable for parameter and column numbrt where that parameter  exists

pdf(paste("BITRATE",".pdf"))
P<-4;
YL<-paste(" Bitrate (Kbps) ")
#######################################################

Ix<-Idf[P];

Ia <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
Ib <- matrix(c(" "," "," "," "," "," "," "," "," "," "), ncol=1)




IIx<-IIdf[P];

IIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)


da<-0;
db<-0;




IIIx<-IIIdf[P];
#IIIb <- matrix(c(" "," "), ncol=1)
IIIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)






for(j in 0:27)
{

for (i in 1:10)
{
  Ia[i]<-(Ia[i]+Ix[i+j*10,]);

  
  IIa[i]<-(IIa[i]+IIx[i+j*10,]);
 

  IIIa[i]<-(IIIa[i]+IIIx[i+j*10,]);



}

}


for (l in 1:10)
{



Ia[l]<-Ia[l]/28;
IIa[l]<-IIa[l]/28;
IIIa[l]<-IIIa[l]/28;


}
        Ib[1]<-paste("Average-Th Last")
	Ib[2]<-paste("QUETRA-Average-Th")
	Ib[3]<-paste("Buffer Based")
        Ib[4]<-paste("BOLA")
	Ib[5]<-paste("QUETRA-Dynamic Alpha")
        Ib[6]<-paste("ELASTIC")
	Ib[7]<-paste("QUETRA-Gradient Based")
	Ib[8]<-paste("QUETRA-KAMA")
	Ib[9]<-paste("QUETRA-Last")
	Ib[10]<-paste("QUETRA-Fixed Alpha")

          

xl<-paste("Bitrate (in Kbps)");
yl<-paste("Average Stall Duration");

trim <- function (x) gsub("^\\s+|\\s+$", "", x);

#postscript(file=str_replace_all(paste("zoom",".eps"), fixed(" "), ""),onefile=FALSE, horizontal=FALSE,paper="special",width=12,height=4);

#width=7,height=5,
#Cx<-union(Ia,IIa)
#Cx<-union(Cx,IIa)
#Cy<-union(Ie,IIe)
#Cy<-union(Cy,IIIe)

 ss<-trellis.par.get("superpose.symbol")
 ss$pch=rep(1,5)
 ss$col=brewer.pal(3, "Set1")
 addalpha(ss$col, 0.1)
  ss$cex=c(0.7,0.7)
 trellis.par.set(superpose.symbol=ss) 

 #Ip=xyplot(Ie~Ia, main = paste("\n         Buffer: 30/60"), data=data.frame(Ie,Ia), pch=1, xlab=" ", ylab=yl,  font.lab=2,group=Ib, cex=(0.01*IinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(-1, 45),xlim=c(1500, 2500) )


aa<-barplot(Ia, width = 5, space =5, beside=TRUE, main=paste("Buffer: 30/60\n"), density = 20 , ylab=YL, col=c(160) ,axisnames=Ia) 
text(x=aa, y=Ia, labels=round(Ia, digits = 2), pos=3,xpd=NA)
text(labels=Ib,x=aa, y=0, srt=45, pos=1, xpd=TRUE)




bb<-barplot(IIa, width = 5, space =5, beside=TRUE, main=paste("Buffer: 120\n"), density = 20 , ylab=YL, col=c(160) ,axisnames=IIa) 
text(x=bb, y=IIa, labels=round(IIa, digits = 2), pos=3,xpd=NA)
text(labels=Ib,x=bb, y=0, srt=45, pos=1, xpd=TRUE)



cc<-barplot(IIIa, width = 5, space =5, beside=TRUE, main=paste("Buffer: 240\n"), density = 20 , ylab=YL, col=c(160) ,axisnames=IIIa) 
text(x=cc, y=IIIa, labels=round(IIIa, digits = 2), pos=3,xpd=NA)
text(labels=Ib,x=cc, y=0, srt=45, pos=1, xpd=TRUE)


 #IIp=xyplot(IIe~IIa, main = paste("       Zoom ","\n","    Buffer: 120"), data=data.frame(IIe,IIa), pch=1, xlab=xl, ylab=NULL, font.lab=2,group=Ib, cex=(0.01*IIinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(-1, 45),xlim=c(1500, 2500))



my.settings <- list(
  par.main.text = list(font = 2, # make it bold
                       just = "left", 
                       x = grid::unit(5, "mm")))



 #IIIp=xyplot(IIIe~IIIa, par.settings=my.settings,main = paste("\n                       Buffer: 240"),  data=data.frame(IIIe,IIIa), pch=1,key = simpleKey(sort(Ib),space="right",cex=c(0.75,0.75)), xlab=" ", ylab=NULL,group=Ib, cex=(0.01*IIIinEFF),  scales=list(cex=c(0.7,0.7)),ylim=c(-1, 45),xlim=c(1500, 2500))


#It=xyplot(1~1 group=IIIb,  key = simpleKey(toupper(IIIb), corner = c(-0.5,0.5),cex=c(0.7,0.7)),ylab=NULL,xlab=NULL, par.settings = list(axis.line = list(col = 0)),scales=list(cex=c(0.1,0.1),x=list(at=NULL),y=list(at=NULL)))
#It=  key = simpleKey(toupper(IIb), space = "right")

#,heights=c(4),widths=c(5,5,5,3)

#It,
#grid.arrange(Ip,IIp,IIIp, ncol=3,widths=c(2,2,3.25))
dev.off()

#dev.off.crop(file=str_replace_all(paste("zoom",".eps"),fixed(" "), ""))



