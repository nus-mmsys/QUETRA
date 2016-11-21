#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
library(gplots)
library(RColorBrewer)
library(grid)
require(crop)




source ('colorRampPaletteAlpha.R')
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


HIdf<-matrix(data = NA, nrow = 9, ncol = 28)
HIIdf<-matrix(data = NA, nrow = 9, ncol = 28)
HIIIdf<-matrix(data = NA, nrow = 9, ncol = 28)
HIcolLabel<-matrix(data = NA, nrow = 1, ncol = 28)


countF<-0;



for(j in 0:27)
{

for (i in 1:9)
{
  Ia[i]<-Ix[i+j*9,]
 # Ib[i]<-paste(Iy[i+j*9,])
  Ie[i]<-Iv[i+j*9,]
  IinEFF[i]<-(7*Iineff[i+j*9,])  
  


  HIdf[i,j+1]<-(Iineff[i+j*9,]) 
  HIIdf[i,j+1]<-(IIineff[i+j*9,]) 
  HIIIdf[i,j+1]<-(IIineff[i+j*9,]) 


 




          Ib[1]<-paste("Avg Throughput")
	
	  Ib[7]<-paste("QUETRA Gradient Based")
	
	  Ib[8]<-paste("QUETRA KAMA")
	
	  Ib[2]<-paste("QUETRA Avg Throughput")
	
	  Ib[3]<-paste("Buffer Based")
	
	  Ib[4]<-paste("BOLA")
	
	  Ib[5]<-paste("QUETRA Dynamic Alpha")
	
	  Ib[6]<-paste("ELASTIC")
	
	  Ib[9]<-paste("QUETRA Fixed Alpha")




HIcolLabel[j+1]<-paste("Profile:",toupper(substr(Iz[i+j*9,],2,2)),", Sample:",toupper(substr(Iu[i+j*9,],2,2)))

}



}

#head(df)
#cols <- c(4,8)
#Idf <- Idf[,cols]

rownames(HIdf) <- paste(Ib)
colnames(HIdf) <- paste(HIcolLabel)

rownames(HIIdf) <- paste(Ib)
colnames(HIIdf) <- paste(HIcolLabel)

rownames(HIIIdf) <- paste(Ib)
colnames(HIIIdf) <- paste(HIcolLabel)







 


HI_matrix <- data.matrix(HIdf)
HII_matrix <- data.matrix(HIIdf)
HIII_matrix <- data.matrix(HIIIdf)

lmat = rbind(c(0,3,0,0),c(0,1,0,4),c(0,2,0,0),c(0,0,0,0))
lwid = c(1,6,1,4)
lhei = c(1,2,2,2)

layout(mat = lmat, widths = lwid, heights = lhei)

setEPS()
postscript("1.eps")

breaks=seq(0, 1, by=0.1) #41 values
#now add outliers



HI_heatmap <- heatmap.2(HI_matrix, Rowv=NA, Colv=NA, cexRow=0.8, cexCol=0.8, breaks=breaks,col = brewer.pal(10, "RdBu"),cex=0.8,main="Buffer: 30/60",lmat = lmat, lwid = lwid, lhei = lhei)
dev.off.crop()
#dev.off.crop(file=str_replace_all(paste(countF,".eps"),fixed(" "), ""))

setEPS()
postscript("2.eps")
HII_heatmap <- heatmap.2(HII_matrix, Rowv=NA, Colv=NA, cexRow=0.8, cexCol=0.8, breaks=breaks,col = brewer.pal(10, "RdBu"),cex=0.4,main="Buffer: 120",lmat = lmat, lwid = lwid, lhei = lhei)
dev.off.crop()
#dev.off.crop(file=str_replace_all(paste(countF,".eps"),fixed(" "), ""))
setEPS()
postscript("3.eps")
HIII_heatmap <- heatmap.2(HIII_matrix, Rowv=NA, Colv=NA, cexRow=0.8, cexCol=0.8, breaks=breaks,col = brewer.pal(10, "RdBu"),cex=0.4,main="Buffer: 240",lmat = lmat, lwid = lwid, lhei = lhei)
dev.off.crop()

