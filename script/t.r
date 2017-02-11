#!/usr/bin/Rscript


args = commandArgs(trailingOnly=TRUE)

df <- read.table(args[1], header = FALSE)
c<-"pdf"
d<-"buff"
fold<-"graph"
output <- unlist(strsplit(args[1], split='.', fixed=TRUE))[1]

name<- paste("TH_R",output,sep="-")
name<- paste(fold,name,sep="/")
name<- paste(name,c,sep=".")
name1<-paste("Buffer_Occupancy",output,sep="-")
name1<- paste(fold,name1,sep="/")
name1<- paste(name1,c,sep=".")

x<-df[2]
y<-cbind(df[4],df[9])
p<-df[4]
a<-df[1]
t<-df[9]
sum <-0;
sumR<-0;
q <-x[lengths(x),];
r<-0;
sumx<-0;
count<-0;
eff<-0;
for (i in 2:lengths(x))
{
  r<-sum
  sum<-(r+((x[i,]-x[i-1,])*p[i,]))

}
sumx<-sum/q;

for (i in 2:lengths(a))
{
  if(a[i,]!=a[i-1,]){
    sumR<-sumR+abs(a[i,]-a[i-1,])
  }
 
  if(t[i,]!=0)
  {
    if(t[i,]>p[i,])
    {
      eff<-eff+((t[i,]-p[i,])/t[i,]);
      count<-count+1;
    }
   
  } 
  
}



pdf(name,onefile=TRUE)
#jpeg("name")
matplot(x,y,type='s', xlab="Time", ylab="MBps",main=output, col=c(rgb(1,0,0,.9),rgb(0,0,1,.3)), lwd="2", lty=1:1, xlim=c(0,700), ylim=c(0,6000))
legend("topright", c("R","D"), col=c(rgb(1,0,0,.9),rgb(0,0,1,.3)), lty=c(1,1),bty="n", horiz=TRUE )
legend("topleft", c(as.expression(paste("Total quality change:",round(sumR,2)))), col=c(rgb(1,0,0,1)),bty="n" )

dev.off()

pdf(name1,onefile=TRUE)
#jpeg("name1")
a<-df[2]
b<-df[6]
par(mar=c(5, 5,2 ,2))
matplot(a,b,type='s', xlab="Time (Sec)", ylab="Buffer Occupancy (Sec)",main=output, col=rgb(1,0,0,1), lwd="2", lty=1:1,cex.axis=1.3, ,cex.axis=2, cex.lab=2, xlim=c(0,900))
#legend("topright", c("Buffer Occupancy"), col=rgb(1,0,0,1), lty=c(1), horiz=TRUE )

dev.off()

