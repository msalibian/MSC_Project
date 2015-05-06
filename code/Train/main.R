# Main script to train the classification tree (CT) and random forest (RF) 
# classifiers. Predictions are also made on the testing data, and are 
# saved to relative paths specified in procedure.R

rm(list=ls())

setwd("C://Users//Ken//Documents//GitHub//MSC_Project")

# load in packages
library(rpart) # fits classification trees
library(plyr) # data wrangling functions
library(randomForest) # fits random forests

# Load in functions from procedure.R, cTree.R, and rForest.R.
source("code//Train//procedure.R")
source("code//Train//cTree.R")
source("code//Train//rForest.R")
source("code//Train//ctApproxRf.R")
load("Matias-CT-50.RData")

# Load in concatenated training data.
datTrn = read.table("data//datTrn.txt", sep=",", header=T)
# Load in concatenated testing data.
datTest = read.table("data//datTest.txt", sep=",", header=T)

# Converts the class variable to a factor so that the variable 
# is regarded as discrete rather than continuous.
datTrn$cl = factor(datTrn$cl)
datTest$cl = factor(datTest$cl)

# See the parameter details in procedure.R.
# k='k' means all features included and k='nok' means only features 
# m1,...,m5
# system.time is only used to track the execution time.
# The following lines of code can be run without the system.time() function
# wrapped around.
system.time(
procedure(k="nok", model="cTree", datTrn=datTrn, datTest=datTest)
)

system.time(
procedure(k="nok", model="rForest", datTrn=datTrn, datTest=datTest)
)

system.time(
procedure(k="k", model="cTree", datTrn=datTrn, datTest=datTest)
)

system.time(
procedure(k="k", model="rForest", datTrn=datTrn, datTest=datTest)
)

procedure(k="k", model="ctApproxRf", datTrn=datTrn, datTest=datTest)



