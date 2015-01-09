
setwd("C://Users//Ken//Documents//GitHub//MSC_Project")

library(rpart)
library(plyr)
library(randomForest)

source("code//Train//procedure.R")
source("code//Train//cTree.R")
source("code//Train//rForest.R")

datTrn = read.table("data//datTrn.txt", sep=",", header=T)
datTest = read.table("data//datTest.txt", sep=",", header=T)

# makes sure the class variable is a factor (so is regarded as 
#  discrete rather than continuous)
datTrn$cl = factor(datTrn$cl)
datTest$cl = factor(datTest$cl)

# we let 'k' resemble all features included
# 'nok' resembles only features m1,...,m5
procedure(k="nok", model="cTree", datTrn=datTrn, datTest=datTest)
procedure(k="nok", model="rForest", datTrn=datTrn, datTest=datTest)
procedure(k="k", model="cTree", datTrn=datTrn, datTest=datTest)
procedure(k="k", model="rForest", datTrn=datTrn, datTest=datTest)






