#!/usr/bin/Rscript
#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
require(crop)


Idf <- read.table("30-60-extended.log", header = FALSE)
IIdf <- read.table("120-extended.log", header = FALSE)
IIIdf <- read.table("240-extended.log", header = FALSE)



Iz<-Idf[1];
Iu<-Idf[2];
Iy<-Idf[3];
Iv<-Idf[13];
Ix<-Idf[4];
Iineff<-Idf[5];
Ia <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
minIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
maxIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
Ib <- matrix(c(" "," "," "," ", " "," "," "," "," "," "), ncol=1)
Ie <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IinEFF <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)



IIz<-IIdf[1];
IIu<-IIdf[2];
IIy<-IIdf[3];
IIv<-IIdf[13];
IIx<-IIdf[4];
IIineff<-IIdf[5];
IIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIb <- matrix(c(" "," "," "," "," ", " "," "," "," "," "), ncol=1)
IIe <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIinEFF <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
minIIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
maxIIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)



IIIz<-IIIdf[1];
IIIu<-IIIdf[2];
IIIy<-IIIdf[3];
IIIv<-IIIdf[13];
IIIx<-IIIdf[4];
IIIineff<-IIIdf[5];
IIIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIIb <- matrix(c(" "," "," "," "," ", " "," "," "," "," "), ncol=1)
IIIe <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
IIIinEFF <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
minIIIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)
maxIIIa <- matrix(c(0,0,0,0,0,0,0,0,0,0), ncol=1)

HIdf<-matrix(data = NA, nrow = 10, ncol = 28)
HIIdf<-matrix(data = NA, nrow = 10, ncol = 28)
HIIIdf<-matrix(data = NA, nrow = 10, ncol = 28)




for(j in 0:27)
{

for (i in 1:10)
{
  
  HIdf[i,j+1]<-Iv[i+j*10,]
  HIIdf[i,j+1]<-IIv[i+j*10,]
  HIIIdf[i,j+1]<-IIIv[i+j*10,]


    


}



}


      Ib[1]<-paste("Avg Throughput")
	
	  Ib[7]<-paste("QUETRA Gradient Based")
	
	  Ib[8]<-paste("QUETRA KAMA")
	
	  Ib[2]<-paste("QUETRA Avg Throughput")
	
	  Ib[3]<-paste("Buffer Based")
	
	  Ib[4]<-paste("BOLA")
	
	  Ib[5]<-paste("QUETRA Dynamic Alpha")
	
	  Ib[6]<-paste("ELASTIC")
	
	  Ib[9]<-paste("QUETRA Fixed Alpha")
          
          Ib[10]<-paste("QUETRA Last")


j<-0;

for(k in 1:10)
{


 for(p in 1:28)
 {
  Ia[k]<-Ia[k]+HIdf[k,p];

 # minIa[k]<-min(HIdf[k,(7*j)+1],HIdf[k,(7*j)+2],HIdf[k,(7*j)+3],HIdf[k,(7*j)+4],HIdf[k,(7*j)+5],HIdf[k,(7*j)+6],HIdf[k,(7*j)+7])

  #maxIa[k]<-max(HIdf[k,(7*j)+1],HIdf[k,(7*j)+2],HIdf[k,(7*j)+3],HIdf[k,(7*j)+4],HIdf[k,(7*j)+5],HIdf[k,(7*j)+6],HIdf[k,(7*j)+7])

 IIa[k]<-IIa[k]+HIIdf[k,p];


 #IIa[k]<-sum(HIIdf[k,(7*j)+1],HIIdf[k,(7*j)+2],HIIdf[k,(7*j)+3],HIIdf[k,(7*j)+4],HIIdf[k,(7*j)+5],HIIdf[k,(7*j)+6],HIIdf[k,(7*j)+7])/7

 # minIIa[k]<-min(HIIdf[k,(7*j)+1],HIIdf[k,(7*j)+2],HIIdf[k,(7*j)+3],HIIdf[k,(7*j)+4],HIIdf[k,(7*j)+5],HIIdf[k,(7*j)+6],HIIdf[k,(7*j)+7])

  #maxIIa[k]<-max(HIIdf[k,(7*j)+1],HIIdf[k,(7*j)+2],HIIdf[k,(7*j)+3],HIIdf[k,(7*j)+4],HIIdf[k,(7*j)+5],HIIdf[k,(7*j)+6],HIIdf[k,(7*j)+7])

  IIIa[k]<-IIIa[k]+HIIIdf[k,p];
 
 #IIIa[k]<-sum(HIIIdf[k,(7*j)+1],HIIIdf[k,(7*j)+2],HIIIdf[k,(7*j)+3],HIIIdf[k,(7*j)+4],HIIIdf[k,(7*j)+5],HIIIdf[k,(7*j)+6],HIIIdf[k,(7*j)+7])/7

  #minIIIa[k]<-min(HIIIdf[k,(7*j)+1],HIIIdf[k,(7*j)+2],HIIIdf[k,(7*j)+3],HIIIdf[k,(7*j)+4],HIIIdf[k,(7*j)+5],HIIIdf[k,(7*j)+6],HIIIdf[k,(7*j)+7])

  #maxIIIa[k]<-max(HIIIdf[k,(7*j)+1],HIIIdf[k,(7*j)+2],HIIIdf[k,(7*j)+3],HIIIdf[k,(7*j)+4],HIIIdf[k,(7*j)+5],HIIIdf[k,(7*j)+6],HIIIdf[k,(7*j)+7])

}

  Ia[k]<-Ia[k]/28
  IIa[k]<-IIa[k]/28
  IIIa[k]<-IIIa[k]/28


}


postscript(file=paste(j+1,".eps"),onefile=FALSE, horizontal=FALSE,paper="special",width=12,height=4);

par(mfrow=c(1,4))

par(mar = c(4, 3, 4, 1)+1 )
#layout(matrix(c(1,2,3,3), 1, 1, byrow = TRUE))



Iaa<-barplot(Ia, width = 5, space =0.5, beside=TRUE , main=paste("Profile:",j+1," Metric: Number of Stalls", "\n","Buffer: 30/60 "), density = 100 ,ylim=c(0,max(Ia)), ylab="Stalls", font.lab = 2,axisnames=Ia,col=brewer.pal(10, "Paired")) 
#arrows(Iaa, minIa, Iaa,       maxIa, lwd = 1.5, angle = 90,       code = 3, length = 0.05)

#par(mar = c(4, 1, 4, 1))
IIaa<-barplot(IIa, width = 5, space =0.5, beside=TRUE , main=paste("Profile:",j+1," Metric: Number of Stalls", "\n","Buffer: 120"), density = 100 ,ylim=c(0,max(IIa)), ylab="Stalls",font.lab = 2, axisnames=IIa,col=brewer.pal(10, "Paired")) 
#arrows(IIaa, minIIa, IIaa,       maxIIa, lwd = 1.5, angle = 90,       code = 3, length = 0.05)

#par(mar = c(4, 1, 4, 1) + 0.4)
IIIaa<-barplot(IIIa, width = 5, space =0.5, beside=TRUE , main=paste("Profile:",j+1," Metric: Number of Stalls", "\n","Buffer: 240 "), density = 100 ,ylim=c(0,max(IIIa)), ylab="Stalls",font.lab = 2, axisnames=IIIa,col=brewer.pal(10, "Paired")) 
#arrows(IIIaa, minIIIa, IIIaa,       maxIIIa, lwd = 1.5, angle = 90,       code = 3, length = 0.05)

dummy <- matrix(c(0), ncol=1)
dummy[1]<-0;

 lty.o <- par("lty")

 par(lty = 0)

 # Also set space to 0, rather
 # than default 0.2, if needed for more room


 # Reset to old value


IIIIaa<-barplot(dummy, axes=FALSE,col=brewer.pal(10, "Paired"),legend.text = Ib,
args.legend = list(x = "right", bty="n", inset=c(0.4,0), xpd = TRUE)) 

 par(lty = lty.o) 

dev.off()
















