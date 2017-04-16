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
library(scales)
args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 4) {
  cat("\nusage: evaluate-avgm.r <metric x> <metric y> <output file name>  <benchmark csv file name>\n")
  cat("       metrics: bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow\n\n")
  quit()
}

metricx <- args[1]
metricy <- args[2]


benchdata <- read.csv(args[4], header = TRUE)
filename <- paste(args[3], '.pdf', sep="")

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
    row <- row[c(metricx, metricy, "method")]

    mean <- colMeans(row[c(metricx, metricy)])
    meanrow <- data.frame(metricx=c(mean[metricx]),
                              metricy=c(mean[metricy]),
                              method=m)
    dt <- rbind(dt, meanrow)
}

pdf(filename,width=12, height=10)  #width 6

if (metricx=="bitrate") {
xlab<-paste("Bitrate (Kbps)");
} else if (metricx=="change")
 {
  xlab<-paste("# Changes in Quality Level ");
 } else if (metricx=="ineff")
 {
  xlab<-paste("Inefficiency");
 } else if (metricx=="stall")
 {
  xlab<-paste("Stall Duration (Sec)");
 } else if (metricx=="numStall")
 {
  xlab<-paste("Number of Stalls");
 } else if (metricx=="avgStall")
 {
  xlab<-paste("Average Stall Duration (Sec)");
 } else if (metricx=="overflow")
 {
 xlab<-paste("Buffer Overflow Duration (Sec)");
  } else if (metricx=="numOverflow")
 {
  xlab<-paste("Number of Buffer Overflow");
 } else if (metricx=="qoe")
 {
  xlab<-paste("QoE");
 }


if (metricy=="bitrate")
 {
  ylab<-paste("Bitrate (Kbps)");
 } else if (metricy=="change")
 {
  ylab<-paste("# Changes in Quality Level");
 } else if (metricy=="ineff")
 {
  ylab<-paste("Inefficiency");
 } else if (metricy=="stall")
 {
  ylab<-paste("Stall Duration (Sec)");
  } else if (metricy=="numStall")
 {
  ylab<-paste("Number of Stalls");
  } else if (metricy=="avgStall")
 {
  ylab<-paste("Average Stall Duration (Sec)");
 } else if (metricy=="overflow")
 {
  ylab<-paste("Buffer Overflow Duration (Sec)");
 } else if (metricy=="numOverflow")
 {
  ylab<-paste("Number of Buffer Overflow");
 } else if (metricy=="qoe")
 {
  ylab<-paste("QoE");
 }



aa<-length(strsplit(paste(dt$method), " "));



print(aa)

print(dt$metricx)
print(dt$metricy)

print((dt$metricy-dt$metricy[dt$method  == "quetra"])/dt$metricy[dt$method  == "quetra"])
print((dt$metricx-dt$metricx[dt$method  == "quetra"])/dt$metricx[dt$method  == "quetra"])


dt$method <- as.character(dt$method )
dt$method [dt$method  == "abr"] <- "Dash.js ABR"
dt$method [dt$method  == "elastic"] <- "ELASTIC"
dt$method [dt$method  == "ar"] <- "Q-Average Throughput"
dt$method [dt$method  == "bb"] <- "BBA"
dt$method [dt$method  == "bba"] <- "BBA"
dt$method [dt$method  == "dy"] <- "Q-Low Pass EMA"
dt$method [dt$method  == "gd"] <- "Q-Gradiant Adaptive EMA"
dt$method [dt$method  == "kama"] <- "Q-KAMA"
dt$method [dt$method  == "quetra"] <- "Q-Last Throughput"
dt$method [dt$method  == "ra"] <- "Q-Exponential Moving Average"
dt$method [dt$method  == "bola"] <- "BOLA"

colnames(dt)[3] <- "Algorithms"

plt <- ggplot()

plt <- plt + geom_point(data=dt,
                       aes(x=metricx,
                           y=metricy,
                           color=Algorithms, shape = Algorithms),size =12, stroke = 3)+ xlim(min(dt$metricx)-(0.1*min(dt$metricx)), max(dt$metricx)+(0.1*max(dt$metricx))) + scale_shape_manual(values = c(0, 6, 1, 5,2,11))

plt <- plt + geom_point(data=dt,
                       aes(x=metricx,
                           y=metricy,
                           color=Algorithms),size =6, shape=43, stroke = 15)+xlim(min(dt$metricx)-(0.1*min(dt$metricx)), max(dt$metricx)+(0.1*max(dt$metricx)))



plt <- plt    + theme_bw() + 
  theme(plot.background = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank() )+
  theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="black", size = 1),
        axis.line.y = element_line(color="black", size = 1)) +theme(plot.margin=unit(c(1,2,1,1),"mm"))+theme(  legend.key = element_rect(fill = "white", colour = "white"))+guides(colour = guide_legend(override.aes = list(size = 5) )) 

plt <- plt +  theme(legend.key.size = unit(0.5, "cm")) + theme(legend.key.height= unit(0.9, "cm")) + theme(legend.key.width= unit(1, "cm"))



plt <- plt + xlim(min(dt$metricx)-(0.1*min(dt$metricx)), max(dt$metricx)+(0.1*max(dt$metricx))) 
plt <- plt +ylim(min(dt$metricy)-(0.1*min(dt$metricy)), max(dt$metricy)+(0.1*max(dt$metricy)))

#plt <- plt +  theme(legend.position="none")

plt <- plt + xlab(xlab) + ylab(ylab)
plt <- plt +  theme(legend.title.align=0.3)
plt <- plt + theme(legend.title = element_text(colour="black", size=14))
plt <- plt + theme(legend.text = element_text(colour="black", size=14))
plt <- plt +theme(axis.line.x = element_line(color="black", size = 1),axis.line.y = element_line(color="black", size = 1)) 
plt <- plt +theme(axis.text.x = element_text(colour="black", size=40),axis.text.y = element_text(colour="black", size=40) ) 
plt <- plt +theme(axis.title.x = element_text(colour="black", size=40),axis.title.y = element_text(colour="black", size=40) ) 
plt <- plt + theme(axis.title.y=element_text(margin=margin(0,20,0,0)))
plt <- plt + theme(axis.title.x=element_text(margin=margin(20,0,5,0)))
plt <- plt + scale_colour_brewer(palette = "Dark2")
       
print(plt)



cat(paste("The file", filename,"is successfully generated.\n"))
