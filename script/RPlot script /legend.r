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

if (length(args) < 5) {
  cat("\nusage: evaluate-avgm.r <metric x> <metric y> <metric size> <output file name>  <csv data file name>\n")
  cat("       metrics: bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow\n\n")
  quit()
}

metricx <- args[1]
metricy <- args[2]
metricSize<-args[3]

benchdata <- read.csv(args[5], header = TRUE)
filename <- paste(args[4], '.pdf', sep="")

if (! (metricx %in% colnames(benchdata))) {
    cat(paste(metricx,"is not a column name\n"))
    quit()
} 

if (! (metricy %in% colnames(benchdata))) {
    cat(paste(metricy,"is not a column name\n"))
    quit()
} 

methods <- unique(benchdata[["method"]])
#Modify to filter the method#
methods <- c("ar", "ra", "quetra", "kama", "gd", "dy")
#methods <- c("abr", "bba", "quetra", "bola", "elastic")

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

pdf(filename,width=4, height=5)

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



aa<-length(strsplit(paste(dt$method), " "));
Ib <- matrix(nrow=aa, ncol=1);


print(aa)

for(i in 1:aa)
{
 
  if(strsplit(paste(dt$method), " ")[i]=="abr"){
   Ib[i] =paste("Dash.js ABR")
   
  } else if(strsplit(paste(dt$method), " ")[i]=="elastic"){
     Ib[i] =paste("ELASTIC")
  } else if(strsplit(paste(dt$method), " ")[i]=="ar"){
     Ib[i] =paste("Q-Average Throughput")
  } else if(strsplit(paste(dt$method), " ")[i]=="bb" | strsplit(paste(dt$method), " ")[i]=="bba"){
     Ib[i] =paste("BBA")
  } else if(strsplit(paste(dt$method), " ")[i]=="dy"){
     Ib[i] =paste("Q-Low pass EMA")
  } else if(strsplit(paste(dt$method), " ")[i]=="gd"){
     Ib[i] =paste("Q-Gradiant Based Alpha")
  } else if(strsplit(paste(dt$method), " ")[i]=="kama"){
     Ib[i] =paste("Q-KAMA")
  } else if(strsplit(paste(dt$method), " ")[i]=="quetra"){
     Ib[i] =paste("QUETRA")
  } else if(strsplit(paste(dt$method), " ")[i]=="ra"){
     Ib[i] =paste("Q-Fixed Alpha")
  } else if(strsplit(paste(dt$method), " ")[i]=="bola"){
     Ib[i] =paste("BOLA")
  }
}

print( Ib[,1])
print(dt$metricSize)

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

colnames(dt)[4] <- "Algorithms"

plt <- ggplot()

plt <- plt + geom_point(data=dt,
                       aes(x=metricx,
                           y=metricy,
                           color=Algorithms),size =dt$metricSize, shape=1, stroke = 2)+ xlim(min(dt$metricx)-(0.1*min(dt$metricx)), max(dt$metricx)+(0.1*max(dt$metricx)))

plt <- plt + geom_point(data=dt,
                       aes(x=metricx,
                           y=metricy,
                           color=Algorithms),size =5, shape=43, stroke = 2)+xlim(min(dt$metricx)-(0.1*min(dt$metricx)), max(dt$metricx)+(0.1*max(dt$metricx)))



plt <- plt    + theme_bw() + 
  theme(plot.background = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank() )+
  theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="white", size = 1),
        axis.line.y = element_line(color="white", size = 1)) +theme(plot.margin=unit(c(1,12,1,10),"cm"))+theme(  legend.key = element_rect(fill = "white", colour = "white"))+guides(colour = guide_legend(override.aes = list(size = 5) ))+ theme(axis.title.x=element_blank(), axis.text=element_blank(), axis.ticks=element_blank()) # +theme(axis.text=element_text(size=20), axis.title=element_text(size=25,face="bold"))

plt <- plt +  theme(legend.key.size = unit(0.5, "cm")) + theme(legend.key.height= unit(0.9, "cm")) + theme(legend.key.width= unit(1, "cm"))

#plt <- plt + scale_size(range = c(4,4))
#plt <- plt +  scale_color_manual(labels = Ib,values = dt$method,name="Algorithms" )

plt <- plt + xlim(min(dt$metricx)-(0.1*min(dt$metricx)), max(dt$metricx)+(0.1*max(dt$metricx))) 
plt <- plt +ylim(min(dt$metricy)-(0.1*min(dt$metricy)), max(dt$metricy)+(0.1*max(dt$metricy)))
#plt <- plt+opts(legend.background = theme_rect(col = 0))

#plt <- plt + ggtitle("Buffer: 120")
#plt <- plt +  theme(legend.position="none")

plt <- plt + xlab("") + ylab("")
plt <- plt +  theme(legend.title.align=0.3)
plt <- plt + theme(legend.title = element_text(colour="black", size=20,face="bold"))
plt <- plt + theme(legend.text = element_text(colour="black", size=20,face="bold"))

        #plt <- plt + ggtitle(paste("                                            Profile: ",substr(p,2,2), ", Sample: ",substr(t,2,2), sep="")) 
        plt <- plt + scale_colour_brewer(palette = "Set1")
        
        
        #plt <- plt +  scale_color_manual(labels = Ib,values = dt[,4],name="Algorithms" )
       
print(plt)



cat(paste("The file", filename,"is successfully generated.\n"))
