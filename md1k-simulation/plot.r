#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  cat("usage: plot <file name>\n")
  quit()
}

df <- read.csv(args[1], header = TRUE, sep = " ")

pdf("xk-rho.pdf")

for (k in unique(df$K)) {
    dfk <- subset(df, K == k)
    p <- ggplot(data=dfk, 
		aes(x=rho, 
		y=Xk, group=BO, 
		colour=BO)) 
    p <- p + geom_line() + geom_point()
    p <- p + ggtitle(paste("K =", k))
    print(p)
}
