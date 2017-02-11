#!/usr/bin/Rscript

library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 5) {
  cat("\nusage: allxy.r <metric x> <metric y> <metric size> <output file name>  <data csv file name>\n")
  cat("       metrics: bitrate,change,ineff,stall,numStall,avgStall,overflow,numOverflow\n\n")
  quit()
}




metricy <- args[1]
metricx <- args[2]
metricSize <- args[3]

benchdata <- read.csv(args[5], header = TRUE)
filename <- paste(args[4], '.pdf', sep="")
pdf(filename,width=12, height=7)

networkprof <- unique(benchdata[["profile"]])
videosample <- unique(benchdata[["sample"]])

methods <- unique(benchdata[["method"]])
# Filter by method
#methods <- c("ar", "ra", "quetra", "kama", "gd", "dy")
#methods <- c("abr", "bba", "quetra", "bola", "elastic")


for (p in networkprof) {
    for (t in videosample) {
      #for(m in methods){
    
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

        benchsubdata <- subset(benchdata, profile==p & sample==t)

        # Filter by method
        benchsubdata <- subset(benchsubdata, method %in% methods)

        benchsubdata <- benchsubdata[c(metricx, metricy, metricSize, "method")]

     
       dt <- benchsubdata
       
  

        
aa<-length(strsplit(paste(dt[,4]), " "));
Ib <- matrix(nrow=aa, ncol=1);


print(aa)


#junk$nm <- as.factor(junk$nm)

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


plt <- ggplot()


plt <- plt + geom_point(data=dt,
                       aes(x=dt[,1],
                           y=dt[,2],
                           color=Algorithms),size =dt[,3], shape=1, stroke = 2) #+ xlim(min(dt[,1])-(0.1*min(dt[,1])), max(dt[,1])+(0.1*max(dt[,1])))

plt <- plt + geom_point(data=dt,
                       aes(x=dt[,1],
                           y=dt[,2],
                           color=Algorithms),size =min(5,dt[,3]), shape=43, stroke = 2) #+xlim(min(dt[,1])-(0.1*min(dt[,1])), max(dt[,1])+(0.1*max(dt[,1])))



plt <- plt    + theme_bw() + 
  theme(plot.background = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank() )+
  theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="black", size = 1),
        axis.line.y = element_line(color="black", size = 1)) +theme(plot.margin=unit(c(1,2,1,1),"cm"))+theme(  legend.key = element_rect(fill = "white", colour = "white"))+guides(colour = guide_legend(override.aes = list(size = 5) ))  +theme(axis.text=element_text(size=20), axis.title=element_text(size=25,face="bold"))

plt <- plt +  theme(legend.key.size = unit(0.5, "cm")) + theme(legend.key.height= unit(0.7, "cm")) + theme(legend.key.width= unit(1, "cm"))

plt <- plt + scale_size(range = c(0,10))
#plt <- plt +  scale_color_manual(labels = Ib,values = dt[,4],name="Algorithms" )

plt <- plt + xlim(min(dt[,1])-(0.1*min(dt[,1])), max(dt[,1])+(0.1*max(dt[,1]))) 
plt <- plt +ylim(min(dt[,2])-(0.1*min(dt[,2])), max(dt[,2])+(0.1*max(dt[,2])))
#plt <- plt+opts(legend.background = theme_rect(col = 0))

#plt <- plt + ggtitle("Buffer: 120")
#plt <- plt +  theme(legend.position="none")

plt <- plt + xlab(ylab) + ylab(xlab)
plt <- plt +  theme(legend.title.align=0.3)
plt <- plt + theme(legend.title = element_text(colour="black", size=12,face="bold"))
plt <- plt + theme(legend.text = element_text(colour="black", size=12,face="bold"))

plt <- plt +theme(axis.line.x = element_line(color="black", size = 1),
        axis.line.y = element_line(color="black", size = 1)) 
        plt <- plt + ggtitle(paste("                                            Profile: ",substr(p,2,2), ", Sample: ",substr(t,2,2), sep="")) 
        plt <- plt + scale_colour_brewer(palette = "Paired")
        
        
        #plt <- plt +  scale_color_manual(labels = Ib,values = dt[,4],name="Algorithms" )
        print(plt)
       
    }
}
#}
cat(paste("The file", filename,"is successfully generated.\n"))
