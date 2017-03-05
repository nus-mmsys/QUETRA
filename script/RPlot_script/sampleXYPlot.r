#!/usr/bin/Rscript

#library(ggplot2)

#library(lattice)
#library(directlabels)
#library(latticeExtra)
#require(gridExtra)
#library(stringr)

library(ggplot2)
library(RColorBrewer)
source ('colorRampPaletteAlpha.R')


args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 4) {
  cat("\nusage: evaluate-avgm.r <metric x> <metric y>  <metric size> <Sample number> <Data csv file name>\n")
  cat("           metrics: bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow\n\n")
  quit()
}

metricx <- args[1]
metricy <- args[2]
metricSize<-args[3]

benchdata <- read.csv(args[5], header = TRUE)
filename <- paste("Sample ",args[4],"-",args[4], '.pdf', sep="")
samplex<- paste("t",args[4],sep="")
print(samplex)
if (! (metricx %in% colnames(benchdata))) {
    cat(paste(metricx,"is not a column name\n"))
    quit()
} 

if (! (metricy %in% colnames(benchdata))) {
    cat(paste(metricy,"is not a column name\n"))
    quit()
} 

methods <- unique(benchdata[["method"]])
methods <- c("abr", "bba", "quetra", "bola", "elastic")
#samples  <- unique(benchdata[["sample"]])
#samples <- c("t5")


 benchdata <- subset(benchdata, sample==samplex)

dt <- data.frame()

    for (m in methods) {

    row <- subset(benchdata, method==m)
   
    
    
    row <- row[c(metricx, metricy,metricSize, "method")]

    mean <- colMeans(row[c(metricx, metricy,metricSize)])
    meanrow <- data.frame(metricx=c(mean[metricx]),
                              metricy=c(mean[metricy]),metricSize=c(mean[metricSize]),
                              method=m)
    dt <- rbind(dt, meanrow)

    }


pdf(filename,width=12, height=7)

if (metricx=="bitrate") {
ylab<-paste("Bitrate (Kbps)");
} else if (metricx=="change")
 {
  ylab<-paste("# Changes in Quality Level ");
 } else if (metricx=="ineff")
 {
  ylab<-paste("Inefficiency");
 } else if (metricx=="stall")
 {
  ylab<-paste("Stall Duration (Sec)");
 } else if (metricx=="numStall")
 {
  ylab<-paste("Number of Stalls");
 } else if (metricx=="avgStall")
 {
  ylab<-paste("Average Stall Duration (Sec)");
 } else if (metricx=="overflow")
 {
 ylab<-paste("Buffer Overflow Duration (Sec)");
  } else if (metricx=="numOverflow")
 {
  ylab<-paste("Number of Buffer Overflow");
 }

if (metricy=="bitrate")
 {
  xlab<-paste("Bitrate (Kbps)");
 } else if (metricy=="change")
 {
  xlab<-paste("# Changes in Quality Level");
 } else if (metricy=="ineff")
 {
  xlab<-paste("Inefficiency");
 } else if (metricy=="stall")
 {
  xlab<-paste("Stall Duration (Sec)");
  } else if (metricy=="numStall")
 {
  xlab<-paste("Number of Stalls");
  } else if (metricy=="avgStall")
 {
  xlab<-paste("Average Stall Duration (Sec)");
 } else if (metricy=="overflow")
 {
  xlab<-paste("Buffer Overflow Duration (Sec)");
 } else if (metricy=="numOverflow")
 {
  xlab<-paste("Number of Buffer Overflow");
 }

#plt <- ggplot()
#plt <- plt + geom_point(data=dt,
#                       aes(x=metricx,
#                           y=metricy,
#                           color=method))

#plt <- plt + xlab(metricx) + ylab(metricy)
#plt <- plt + ggtitle("all profiles and samples")
#print(plt)


Ib <- matrix(c(" "," "," "," "," "), ncol=1);


aa<-length(strsplit(paste(dt$method), " "));

print(aa)

dt$method <- as.character(dt$method )
dt$method [dt$method  == "abr"] <- "Dash.js ABR"
dt$method [dt$method  == "elastic"] <- "ELASTIC"
dt$method [dt$method  == "ar"] <- "Q-Average Throughput"
dt$method [dt$method  == "bb"] <- "BBA"
dt$method [dt$method  == "bba"] <- "BBA"
dt$method [dt$method  == "dy"] <- "Q-Low pass EMA"
dt$method [dt$method  == "gd"] <- "Q-Gradiant Based Alpha"
dt$method [dt$method  == "kama"] <- "Q-KAMA"
dt$method [dt$method  == "quetra"] <- "QUETRA"
dt$method [dt$method  == "ra"] <- "Q-Fixed Alpha"
dt$method [dt$method  == "bola"] <- "BOLA"
print( Ib[,1])
colnames(dt)[4] <- "Algorithms"
print(dt)


print( Ib[,1])
print(dt$metricy)


#xyplot(dt$metricx~dt$metricy, main = paste("\n         Buffer: 30/60"), auto.key=TRUE  ,data=dt, cex=2,pch=1, xlab=xlab, ylab=xlab, col=brewer.pal(8, "Dark2"), font.lab=2, scales=list(cex=c(0.7,0.7)))
#ylim=c(min(metricy), max(metricy)),xlim=c(min(metricx), max(metricx)) key=list(space="right", text=Ib)
   plt <- ggplot()
#plt <-plt + scale_colour_brewer(palette = "Greens")




plt <- plt + geom_point(data=dt,
                       aes(x=metricx,
                           y=metricy,
                           color=Algorithms),size =dt$metricSize, shape=1, stroke = 2) #+ xlim(min(dt$metricx)-100, max(dt$metricx)+100) 

plt <- plt + geom_point(data=dt,
                       aes(x=metricx,
                           y=metricy,
                           color=Algorithms),size =3, shape=43, stroke = 2)  #+ xlim(min(dt$metricx)-100, max(dt$metricx)+100) 



plt <- plt    + theme_bw() + 
  theme(plot.background = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank() )+
  theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="black", size = 1),
        axis.line.y = element_line(color="black", size = 1)) +theme(plot.margin=unit(c(1,2,1,1),"cm"))+theme(  legend.key = element_rect(fill = "white", colour = "white"))+guides(colour = guide_legend(override.aes = list(size = 5) ))  +theme(axis.text=element_text(size=20), axis.title=element_text(size=25,face="bold"))

plt <- plt +  theme(legend.key.size = unit(0.5, "cm")) + theme(legend.key.height= unit(0.7, "cm")) + theme(legend.key.width= unit(1, "cm"))

#plt <- plt + theme(plot.margin = unit(c(1,1,1,1), "cm"))
plt <- plt + scale_size(range = c(4,4))
#plt <- plt +  scale_color_manual(labels = Ib,values = dt$method,name="Algorithms" )


plt <- plt + xlab(ylab) + ylab(xlab)
plt <- plt +  theme(legend.title.align=0.3)
plt <- plt + theme(legend.title = element_text(colour="black", size=12,face="bold"))
plt <- plt + theme(legend.text = element_text(colour="black", size=12,face="bold"))

plt <- plt +theme(axis.line.x = element_line(color="black", size = 1),
        axis.line.y = element_line(color="black", size = 1)) 
         
        plt <- plt + scale_colour_brewer(palette = "Paired")
        
        
        #plt <- plt +  scale_color_manual(labels = Ib,values = dt[,4],name="Algorithms" )
        print(plt)
 

#plt +  scale_colour_brewer( palette="Dark2")




#xyplot(dt$metricx~dt$metricy,xlab=xlab, ylab=ylab,   )


cat(paste("The file", filename,"is successfully generated.\n"))
