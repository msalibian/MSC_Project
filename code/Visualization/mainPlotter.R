# Main script for generating the visualizations of fig 2 and 3. Uses the
# class prediction data matrices called resDf (recall from mainFbTree.m, 
# cTree.R, and rForest.R) to construct plots of the success rates of each 
# classifier to assess the predictive performances.

setwd("C://Users//Ken//Documents//GitHub//MSC_Project")

# Load in some R libraries.
library(plyr) # data wrangling functions
library(ggplot2) # plotting
library(RColorBrewer) # colors
library(grid) # has a function to modify the width of legend

source("code//Visualization//plotter.R")

# k="k" means include the additional features into the proposed classifiers
# k="nok" means only use features m1, m2,..., m5. 
k = c("k", "nok")
# models include FBT, CT, RF, and CT-Approx RF
models = c("fbTree", "cTree", "rForest", "ctApproxRf")

# Set up parameters to input into the plotting function (see plotter.process).
combnDf = expand.grid("model"=models, "k"=k)
combnDf = subset(combnDf, !(model=="fbTree" & k=="k"))
combnDf = subset(combnDf, !(model=="ctApproxRf" & k=="nok"))

# Plots out figures 2 and 3 in the manuscript.
plotter.process(combnDf)




