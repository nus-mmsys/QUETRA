#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
  cat("usage: plot <file name>\n")
  quit()
}

df <- read.csv(args[1], header = TRUE, sep = " ")

klist <- unique(df$K)

for (k in klist) {
    dfk <- subset(df, K == k)
    pdf(paste(k, ".pdf", sep=""))
    p <- ggplot(data=dfk, 
		aes(x=rho, 
		y=Xk, group=BO, 
		colour=BO)) 
    p <- p + geom_line() + geom_point()
    p <- p + ggtitle(paste("K =", k))
    print(p)
}
