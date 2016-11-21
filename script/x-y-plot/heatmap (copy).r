#!/usr/bin/Rscript

library(lattice)
library(directlabels)
library(latticeExtra)
require(gridExtra)
library(stringr)
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


row.names(Idf) <- paste(toupper(Idf[,1]),toupper(Idf[,2]),toupper(Idf[,3]))



postscript((file="f1.eps"),onefile=FALSE, horizontal=FALSE);
cols <- c(4,8)
Idf <- Idf[,cols]
nba_matrix <- data.matrix(Idf)

nba_heatmap <- heatmap(nba_matrix, Rowv=NA, Colv=NA, cexCol=0.5,col = brewer.pal(9, "Set1"))


dev.off()

