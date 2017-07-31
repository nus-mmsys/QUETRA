#!/usr/bin/Rscript

#library(ggplot2)

#library(lattice)
#library(directlabels)
#library(latticeExtra)
#library(stringr)

library(ggplot2)
library(gridExtra)
library(RColorBrewer)
library(lattice)
library(directlabels)
library(latticeExtra)
library(stringr)
source ('colorRampPaletteAlpha.R')
library(scales)
args <- commandArgs(trailingOnly=TRUE)

# Setup axis labels
# map metric to human readable labels
labels <- new.env()
labels[['bitrate']] <- "Average Bitrate (kbps)"
labels[['change']] <- "Changes in Representation"
labels[['ineff']] <- "Inefficiency"
labels[['stall']] <- "Stall Duration (Sec)"
labels[['numStall']] <- "Number of Stalls"
labels[['avgStall']] <- "Average Stall Duration (Sec)"
labels[['overflow']] <- "Buffer Full Duration (Sec)"
labels[['numOverflow']] <- "Number of Buffer Overflow"
labels[['qoe']] <- "QoE ( x100,000)"

methodname <- new.env()
methodname[['abr']] <- "Dash.js ABR  "
methodname[['elastic']] <- "ELASTIC  "
methodname[['qAvgTh']] <- "Avg Th"
methodname[['bba']] <- "BBA  "
methodname[['quetra']] <- "QUETRA"
methodname[['bola']] <- "BOLA  "
methodname[['qLowPassEMA']] <- "Low Pass EMA"
methodname[['qGradientEMA']] <- "Gradient EMA"
methodname[['qKAMA']] <- "KAMA"
methodname[['qEMA']] <- "EMA"

theme_quetra <- function(base_size = 12, base_family = "Helvetica"){
  axis_label_size <- 42
  axis_title_size <- 48
  theme_classic(base_size = base_size, base_family = base_family) %+replace%
    theme(
      axis.title = element_text(size = axis_title_size),
      axis.line.x = element_line(color="black", size = 1),
    	axis.line.y = element_line(color="black", size = 1),
      legend.key = element_rect(colour=NA, fill =NA),
      legend.title = element_blank(),
      legend.text = element_text(size = axis_label_size, margin=margin(40,40,40,40)),
      legend.margin = margin(40,40,40,40),
      legend.position = "bottom",
      legend.spacing = unit(4, "cm"),
      legend.key.size = unit(50, 'pt'),
      #panel.grid = element_blank(),
      panel.border = element_rect(fill = NA, colour = "black", size=3),
      panel.spacing.x = unit(-5,'pt'),
      panel.background = element_rect(fill = "white", colour = "black"),
      strip.background = element_rect(fill = "white", colour= "white"),
      strip.text.x = element_text(size = axis_label_size,  margin=margin(40,0,40,0)),
      axis.text = element_text(size = axis_label_size),
      axis.title.x = element_text(
          margin=margin(40,0,5,0)),
      axis.title.y = element_text(
          angle = 90,
          margin=margin(0,40,0,5)),
      plot.title = element_text(
          face = 'bold',
          hjust = 0.5,
          size = 40),
      )
}

check_valid_column <- function(colname, input_data) {
  if (! (colname %in% colnames(input_data))) {
	  cat(paste(metricx,"is not a valid column name\n"))
	  quit()
  }
}
# Figure 4 consists of two rows, three figures each.  The top row plots number
# of changes vs. average bitrate.  The second row plots number of stalls vs.
# stall duration.

plot_x_y <- function(dt, metricx, metricy, methods) {
  check_valid_column(metricx, dt)
  check_valid_column(metricy, dt)
  dt$method <- as.character(dt$method)
  for (m in methods) {
    dt$method[dt$method == m] <- methodname[[m]]
  }
  dt$method <- as.factor(dt$method)

  colnames(dt)[colnames(dt)==metricx] <- 'metricx'
  colnames(dt)[colnames(dt)==metricy] <- 'metricy'

  dt$bufSizeF <- factor(dt$bufSize, levels=c('30/60','120','240'), labels=c("30/60 s", "120 s", "240 s"))

  ylab <- labels[[metricy]]
  xlab <- labels[[metricx]]

  plt <- ggplot(dt, aes(
					x = metricx,
					y = metricy,
					color = method,
					shape = method
          ))

  # plot the shapes
  plt <- plt + geom_point(
					size = 12,
					stroke = 3) +
		scale_shape_manual(values = c(0, 6, 1, 5, 2, 11)) +
    facet_grid(. ~ bufSizeF)

  plt <- plt + geom_point(
					size = 6,
					shape = 43,
					stroke = 15) +
    facet_grid(. ~ bufSizeF)

  plt <- plt + xlab(xlab) + ylab(labels[[metricy]])

	plt <- plt + theme_quetra()
	plt <- plt + scale_colour_brewer(palette = "Set1")
	plt <- plt + guides(shape=guide_legend(nrow = 1))

	return(plt)
}

plotBar <- function(dt, metric, methods) {
         check_valid_column(metric, dt) 
         dt$method <- as.character(dt$method)
         target<-adaptation_methods
         for (m in methods) {
          dt$method[dt$method == m] <- methodname[[m]]
           for(i in 1:length(target))
           {
             if(target[i] == m){ target[i] <- methodname[[m]]}  
           }

         }
        dt$method <- as.factor(dt$method)
	dtI <- subset(dt, dt$bufSize == '30/60' )
	dtII <- subset(dt, dt$bufSize == '120' )
	dtIII <- subset(dt, dt$bufSize == '240')
        dat <- cbind(dtI[metric],dtII[metric],dtIII[metric])
        
       	colnames(dat) <- c("30/60", "120" ,"240")
	rownames(dat) <- dtI$method
        dat <- dat[with(dat, target), ] #reoreder rows
        angle1 <- rep(c(45,45,135), length.out=3)
	angle2 <- rep(c(45,135,135), length.out=3)
	density1 <- seq(6,12,length.out=3)
	density2 <- seq(6,12,length.out=3)
       
       
       if(metric == 'qoe'){ 
         dat<-dat/100000
         ylim<-c(-0.2,5)
         inset<-c(0,-0.1)
       }
        
       if(metric == 'overflow'){ 
         ylim<-c(-3,80)
         inset<-c(0,-0.1)
       } 

	par(mar=c(4,8,7.5,2) )

	angle1 <- rep(c(45,45,135), length.out=3)
	angle2 <- rep(c(45,135,135), length.out=3)
	density1 <- seq(6,12,length.out=3)
	density2 <- seq(6,12,length.out=3)
	barplot(t(dat), main="",beside=TRUE, col=c("darkblue","red","green"),ylab="", ylim=ylim,cex.names=3,cex.axis=3, angle=angle2, density=density2 ) 
	barplot(t(dat), main="",beside=TRUE,add=TRUE, col=c("darkblue","red","darkgreen"),ylab="",cex.names=3,cex.axis=3, angle=angle1, density=density1 ) 
	title(ylab=labels[[metric]], line=5, cex.lab=3, font = 1)
	par(xpd=TRUE)
	legend("topright",legend = c("30/60","120","240"), ncol = 3,  fill =c("darkblue","red","darkgreen"),cex = 3, title="Buffer Capacity (Sec)",  bty = "n",inset=inset,angle=angle1, density=density1)
	par(bg="transparent")
	legend("topright",legend = c("30/60","120","240"), ncol = 3,  fill =c("darkblue","red","darkgreen"),cex = 3, title="Buffer Capacity (Sec)",  bty = "n",inset=inset,angle=angle2, density=density2)



}

# Setup two sets of graphs
smoothing_methods <- c("qAvgTh", "qEMA", "quetra", "qKAMA", "qGradientEMA", "qLowPassEMA")
adaptation_methods <- c("abr", "bola", "elastic", "bba", "quetra" )

# Read input file
input_data <- read.csv("results.csv", header = TRUE)

# Agreegate the mean over all profiles and all samples
mean_dt <- aggregate(.~method+bufSize, data=input_data, mean)
dt <- subset(mean_dt, mean_dt$method %in% adaptation_methods)

pdf("fig4a.pdf",width=22, height=10)
print(
  plot_x_y(dt, 'change','bitrate', adaptation_methods) + theme(legend.position = "none") + 
  	scale_y_continuous(breaks=seq(1500, 2400, by=300), limit=c(1500, 2400)) +
  	scale_x_continuous(breaks=seq(0, 200, by=50), limit=c(0, 220)) 
  )
pdf("fig4b.pdf",width=22, height=12)
print(
  plot_x_y(dt, 'stall','numStall', adaptation_methods) +
  	scale_y_continuous(breaks=seq(2.5, 5, by=0.5), limit=c(2.4, 5)) +
  	scale_x_continuous(breaks=seq(5, 20, by=5), limit=c(4.5, 21)) 
  )

mean_dt <- aggregate(.~method+bufSize+sample, data=input_data, mean)
dt <- subset(mean_dt, mean_dt$sample == 'v5' & mean_dt$method %in%
adaptation_methods)
pdf("fig7.pdf",width=22, height=12)
print(
  plot_x_y(dt, 'change','bitrate', adaptation_methods)+
  	scale_y_continuous(breaks=seq(1200, 2200, by=250), limit=c(1150, 2200)) +
  	scale_x_continuous(breaks=seq(5, 35, by=10), limit=c(0, 35)) 
  )

mean_dt <- aggregate(.~method+bufSize, data=input_data, mean)
dt <- subset(mean_dt, mean_dt$method %in% smoothing_methods)
methodname[['quetra']] <- "Last Th"

pdf("fig9.pdf",width=22, height=12)
print(
  plot_x_y(dt, 'change','bitrate', smoothing_methods) +
  	scale_colour_brewer(palette = "Dark2") +
  	scale_y_continuous(breaks=seq(1500, 2500, by=250), limit=c(1500, 2500)) +
  	scale_x_continuous(breaks=seq(0, 60, by=20), limit=c(0, 65))
  )

mean_dt <- aggregate(.~method+bufSize, data=input_data, mean)
dt <- subset(mean_dt, mean_dt$method %in% adaptation_methods)
methodname[['quetra']] <- "QUETRA"
pdf("fig5.pdf",width=22, height=14)
plotBar(dt,'qoe',adaptation_methods)
pdf("fig8.pdf",width=22, height=16)
plotBar(dt,'overflow',adaptation_methods)



