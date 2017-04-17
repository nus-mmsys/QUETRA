#!/usr/bin/Rscript

#library(ggplot2)

#library(lattice)
#library(directlabels)
#library(latticeExtra)
#library(stringr)

library(ggplot2)
library(gridExtra)
library(RColorBrewer)
source ('colorRampPaletteAlpha.R')
library(scales)
args <- commandArgs(trailingOnly=TRUE)

# Setup axis labels
# map metric to human readable labels
labels <- new.env()
labels[['bitrate']] <- "Average Bitrate (kbps)"
labels[['change']] <- "Changes in Representation"
labels[['ineff']] <- "Inefficiency"
labels[['stall']] <- "Stall Duration (s)"
labels[['numStall']] <- "Number of Stalls"
labels[['avgStall']] <- "Average Stall Duration (s)"
labels[['overflow']] <- "Buffer Overflow Duration (s)"
labels[['numOverflow']] <- "Number of Buffer Overflow"
labels[['qoe']] <- "QoE"

methodname <- new.env()
methodname[['abr']] <- "dash.js ABR  "
methodname[['elastic']] <- "ELASTIC  "
methodname[['ar']] <- "Q-Avg Throughput  "
methodname[['bba']] <- "BBA  "
methodname[['quetra']] <- "QUETRA  "
methodname[['bola']] <- "BOLA  "
methodname[['dy']] <- "Q-Low Pass EMA  "
methodname[['gd']] <- "Q-Gradient-based EMA  "
methodname[['kama']] <- "Q-KAMA"
methodname[['ra']] <- "Q-EMA"

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
      panel.border = element_rect(fill = NA, colour = "black", size=1),
      panel.spacing.x = unit(0,'pt'),
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

plot_x_y <- function(metricx, metricy, csv_input_filename) {
  input_data <- read.csv(csv_input_filename, header = TRUE)
  check_valid_column(metricx, input_data)
  check_valid_column(metricy, input_data)

  dt <- aggregate(.~method+bufSize, data=input_data, mean)
  #methods <- c("abr", "bba", "quetra", "bola", "elastic")
  methods <- c("ar", "ra", "quetra", "kama", "gd", "dy")
  dt <- subset(dt, dt$method %in% methods)
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
		scale_shape_manual(values = c(0, 6, 1, 5,2,11)) +
    facet_grid(. ~ bufSizeF)

  plt <- plt + geom_point(
					size = 6,
					shape = 43,
					stroke = 15) +
    facet_grid(. ~ bufSizeF)
 # plt <- plt +scale_y_continuous( breaks=seq(1500, 2500, by=250),limit=c(1500,2500))
  #plt <- plt +scale_x_continuous( breaks=seq(0, 60, by=20),limit=c(0,62))
  plt <- plt + xlab(xlab) + ylab(labels[[metricy]])

	plt <- plt + theme_quetra()
	plt <- plt + scale_colour_brewer(palette = "Dark2")

	return(plt)
}

pdf("fig5a.pdf",width=22, height=10)
print(
  plot_x_y('change','bitrate',"results.csv") + theme(legend.position = "none")
  )
#pdf("fig5b.pdf",width=22, height=12)
#print(
  #plot_x_y('stall','numStall',"results.csv")
  #)
