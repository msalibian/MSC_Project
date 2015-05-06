# Script to concatenate together training and testing data sets from each 
# modulation. 
# There should be two data sets: training and testing containing 
# data from all of the six simulated modulation data.
# The training and testing data sets are written to a relative 
# specified at the write.table call.

rm(list=ls())

setwd("C://Users//Ken//Documents//GitHub//MSC_Project")

# Load in library to make data manipulations easier.
library(plyr)

# Specify the relative path to the modulation data for each of the 
# six modulations.
inPath = "data//Modulation"
# Specify the number of observations per modulation and SNR. Recall this 
# value is 'P' and 'P2' in the mainFbTree.m script.
sizeTrn = 200
sizeTest = 1100

# Find all the files corresponding to training and testing data.
infsTrn = list.files(inPath, pattern=paste0("P", sizeTrn), full.names=T)
infsTest = list.files(inPath, pattern=paste0("P", sizeTest), full.names=T)

# List column names from a text file.
colNames = read.table("data//namesDat.txt", header=F, 
						stringsAsFactors=F)[,1]

# The following function takes a file name x and list of column names 
# as specified above and reads in the training data corresponding to 
# x and passes in the list of column names as the header of the 
# training data.
readData = function(x, colNames){
	out = read.table(x, header=F, sep=",", col.names=colNames)
}

# Function that iterates through each input file name of the 
# modulation training data sets, and applies readData.
# The data are concatenated row-wise.
# This process is performed on both the training and testing data.
datTrn = ldply(infsTrn, .fun=readData, colNames=colNames)
datTest = ldply(infsTest, .fun=readData, colNames=colNames)

write.table(datTrn, file="data//datTrn.txt", sep=",")
write.table(datTest, file="data//datTest.txt", sep=",")


