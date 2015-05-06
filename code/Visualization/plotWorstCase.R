
setwd("C://Users//Ken//Documents//GitHub//MSC_Project")

library(ggplot2)
library(reshape2)

dat = read.table("data//worstCaseDat.txt", header=F, sep=",")

names(dat) = c("SNR", "bpsk", "bfskA")
ggdata = melt(dat, id.vars="SNR", measure.vars=c("bpsk","bfskA"), 
          variable.name="Modulation", value.name="m1")

gg = ggplot(ggdata, aes(x=SNR, y=m1)) + 
      geom_line(size=1.2, aes(color=Modulation))





