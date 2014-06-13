
rm(list=ls())

setwd("/ubc/ece/home/ll/grads/kenl/MSC_Project")

library(rpart)
library(plyr)
library(stringr)
library(R.utils)
library(randomForest)

source("Code/Train/Main/Methods/sourceFiles.R")

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
		
ddply(combnDfRf, .(m, k, n, nmod, model), inplyrGeneric, 
	.Object="RandomForest", parser=parser)
	
	
	
	