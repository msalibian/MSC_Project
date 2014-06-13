
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

paramGrid = new("ParamGrid")
paramGrid = buildParams(paramGrid)

modelProcedure = new("ModelProcedure", paramGrid=paramGrid, 
									parser=parser)

automate(modelProcedure)									
									
									


#sourceDirectory("Code/Train/Main/Methods", modifiedOnly=F);

#load source functions for sourcing R class files
#source("Code/Train/Main/Methods/sourceFiles.R")

#do all the data retrieval and munging if necessary
#processData()

#set up parameter df for different cases for verification
#buildParams()

#d_ply(combnDf, .(m, k, n, nmod, model), .fun=modelMainWrapper, 
#	datTrn=datTrn, datTest=datTest, N=N, P=P, snrdbRange=snrdbRange) 

	
	