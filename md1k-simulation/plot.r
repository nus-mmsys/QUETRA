#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  cat("usage: plot <file name>\n")
  quit()
}

df <- read.csv(args[1], header = TRUE, sep = " ")

klist <- unique(df$K)
bolist <- unique(df$BO)

for (k in klist) {
    dfk <- subset(df, K == k)
    print(dfk)
    
    p <- matplot(dfk$rho, dfk$Xk, group=dfk$BO, type='l') 
}

#print(klist)
#print(bolist)

#print(data)

