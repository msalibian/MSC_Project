
setwd("C://Users//Ken//Documents//GitHub//MSC_Project")

library(plyr)
library(ggplot2)
library(RColorBrewer)

source("code//Visualization//plotter.R")

k = c("k", "nok")
models = c("fbTree", "cTree", "rForest")
combnDf = expand.grid("model"=models, "k"=k)
# fbTree only uses m1,...,m5
combnDf = subset(combnDf, !(model=="fbTree" & k=="k"))

plotter.process(combnDf)


