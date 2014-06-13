
rm(list=ls())

#setwd("/ubc/ece/home/ll/grads/kenl/MSC_Project")
setwd("C://Users//Ken//Documents//GitHub//MSC_Project//Development")

library(rpart)
library(plyr)
library(stringr)
library(R.utils)
library(randomForest)
library(doSNOW)
library(snow)

source("Main//Methods//sourceFiles.R")

objParser = new("Parser")
parser = importParse(objParser)

### RandomForest ###

paramGridRf = new("ParamGrid", models="RandomForest")
paramGridRf = buildParams(paramGridRf)
combnDfRf = paramGridRf@combnDf									

inplyrGeneric = function(xCombnDf, .Object, parser){
	experimentProcedure(.Object=.Object, xCombnDf=xCombnDf, 
		parser=parser)
}

cl<-makeCluster(3)
registerDoSNOW(cl)

ddply(combnDfRf, .(m, k, n, nmod, model), inplyrGeneric, 
	.Object="RandomForest", parser=parser, .parallel=TRUE)
	
stopCluster(cl)	
	
	