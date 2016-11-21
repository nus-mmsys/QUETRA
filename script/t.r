#!/usr/bin/Rscript


args = commandArgs(trailingOnly=TRUE)

df <- read.table(args[1], header = FALSE)
c<-".jpg"
d<-"buff"
name<- paste(args[1],c)
name1<-paste(args[1],d,c)

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



jpeg(name)

matplot(x,y,type='s', xlab="Time", ylab="MBps", col=c(rgb(1,0,0,.9),rgb(0,0,1,.3)), lwd="2", lty=1:1, xlim=c(0,600), ylim=c(0,8000))

legend("topright", c("R","D"), col=c(rgb(1,0,0,.9),rgb(0,0,1,.3)), lty=c(1,1),bty="n", horiz=TRUE )
legend("topleft", c(as.expression(paste("Inefficiency ",round(eff/count,4))), as.expression(paste("Total quality change:",round(sumR,2)))), col=c(rgb(1,0,0,1), rgb(1,0,0,1)),bty="n" )

dev.off()

jpeg(name1)
a<-df[2]
b<-df[6]
matplot(a,b,type='s', xlab="Time", ylab="Sec", col=rgb(1,0,0,1), lwd="2", lty=1:1, xlim=c(0,600))
legend("topright", c("Buffer"), col=rgb(1,0,0,1), lty=c(1), horiz=TRUE )



