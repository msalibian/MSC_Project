# Plotting class which contains methods that plots out figures 2 and 3 of 
# the manuscript. In particular, the plotter.process function performs the 
# plotting given the parameters in mainPlotter.R

# Reads an indivdual row of the input parameters specified in mainPlotter.R
# and reads in the corresponding files of resDf at the relative path given 
# by the model name and k variables. The resDf files contain the SNR, 
# true labels, and predicted labels as mentioned in fbTree.m, cTree.R, and 
# rForest.R.
# Concatenate a new column to each resDf data which indicates whether 
# the prediction is correct or not.
# 
plotter.readFile = function(xCombnDf){
  model = xCombnDf$model
  inf = paste0("data//Fitted//", model)
  k = xCombnDf$k
  if(grepl("fbTree", model, ignore.case=T)){
    inf = paste0(inf, "//", model, ".txt")
    resDf = read.table(inf, header=F, sep=",")
  } else {
    inf = paste0(inf, "//", model, "_", k, ".txt")
    resDf = read.table(inf, header=T, sep=",")
  }
  names(resDf) = c("snrdB", "cl", "pr")
  resDf$res = (resDf$cl == resDf$pr)
  return(resDf)
}

# a = subset(resDf, snrdB==-25 & cl==1)
# sum(a$res)/nrow(a)
# a = subset(resDf, snrdB==-25 & cl==2)
# sum(a$res)/nrow(a)
# a = subset(resDf, snrdB==-25 & cl==3)
# sum(a$res)/nrow(a)
# a = subset(resDf, snrdB==-25 & cl==4)
# sum(a$res)/nrow(a)
# a = subset(resDf, snrdB==-25 & cl==5)
# sum(a$res)/nrow(a)
# a = subset(resDf, snrdB==-25 & cl==6)
# sum(a$res)/nrow(a)

# Reads in the resDf with the new columns indicating whether predictions 
# are correct. 
# Group resDf by SNR and compute the success rate. 
#
plotter.aggregate = function(resDf){
  out = ddply(resDf, .(snrdB), .fun=summarize, "sr"=mean(res))
  return(out)
}

# Computes the success rate of a single combination of model and k 
# variables by calling the functions plotter.readFile and plotter.aggregate.
#
plotter.summarize = function(xCombnDf){
  resDf = plotter.readFile(xCombnDf)
  resDfType = plotter.aggregate(resDf)
  # set row names to NULL, this allows to combine with another dataframe
  row.names(xCombnDf) = NULL
  out = data.frame(xCombnDf, resDfType)
  return(out)
}

# Iterates through all combinations of model and k input parameters specified 
# in the input of plotter.process and calls the function plotter.summarize 
# to compute the success rates of each combination of model and 
# features included.
#
plotter.generateSummaries = function(combnDf){
  out = ddply(combnDf, .(model, k), .fun=plotter.summarize)
  return(out)
}

plotter.generatePlots = function(combnDf, resDfType){
  
  ggdata1 = subset(resDfType, k == "nok")
  ggdata2 = subset(resDfType, k == "k")
  ggdata2 = rbind(ggdata2, subset(resDfType, model=="fbTree"))
  plotter.plot(ggdata1)
  plotter.plot(ggdata2)
  
}

plotter.parseTitle = function(ggdata){
  k = unique(ggdata$k)
  if(length(k) > 1){
    out = "Model Comparison: All Features"
  } else {
    out = "Model Comparison: 5 Key Features"
  }
  return(out)
}

plotter.parseLegend = function(ggdata){
  out = ggdata
  out$processCombn = out$model
  hashTable = c("rForest"="Random Forest", 
                "cTree"="Classification Tree", 
                "fbTree"="Feature-Based Tree",
                "ctApproxRf"="CT-Approx RF")
  out$processCombn = revalue(out$processCombn, hashTable)
  return(out)
}

plotter.plot = function(ggdata){
  
  ggdata = plotter.parseLegend(ggdata)
  if(length(unique(ggdata$model)) == 3){
    colours1 = brewer.pal(n=9, "Greys")[9]
    #colours1 = c(colours1, brewer.pal(n=9, "Greens")[5])
    #colours1 = c(colours1, brewer.pal(n=9, "Oranges")[3])
    colours1 = c(colours1, "#FF0000")
    colours1 = c(colours1, "#FE4EDA")
    lineValues = c(1,5,6)
  } else {
    colours1 = brewer.pal(n=9, "Greys")[9]
    colours1 = c(colours1, brewer.pal(n=9, "Blues")[8])
    #colours1 = c(colours1, brewer.pal(n=9, "Greens")[5])
    #colours1 = c(colours1, brewer.pal(n=9, "Oranges")[3])
    colours1 = c(colours1, "#FF0000")
    colours1 = c(colours1, "#FE4EDA")    
    lineValues = c(1,3,5,6)
  }
  
  xBreaks = seq(min(ggdata$snrdB), max(ggdata$snrdB), by=4)
  if(!max(ggdata$snrdB)%in%xBreaks) {
    xBreaks = c(xBreaks, max(ggdata$snrdB))
  }
  yBreaks = c(.15, seq(.2, 1, by=.1))
	gg = ggplot(ggdata, aes(x=snrdB, y=sr, 
          linetype=reorder(processCombn, desc(sr), mean), 
        color=reorder(processCombn, desc(sr), mean))) + 
        geom_line(size=1.3) + xlab("SNR (dB)") + 
        ylab("Success Rate") + 
        theme(axis.title=element_text(size=17), 
          axis.text=element_text(size=16), title=element_text(size=17),
          legend.text=element_text(size=15), 
          legend.title=element_text(size=13), 
          legend.position=c(.788, .175), 
          legend.key.width=unit(2.2, "cm")) + 
        scale_color_manual("Classifiers", values=colours1) +
        scale_linetype_manual(name="Classifiers", values=lineValues) +
        scale_x_continuous(breaks=xBreaks) + 
        scale_y_continuous(breaks=yBreaks) + 
        labs(aesthetic="Classifiers")
  
  k = unique(ggdata$k)
  outf = paste0("visualizations//pred-performance-", k, ".pdf")
  ggsave(outf, gg, width=8, height=6)
  outf = paste0("visualizations//pred-performance-", k, ".png")
  ggsave(outf, gg, width=8, height=6)
  
}

plotter.process = function(combnDf){
  
  resDfType = plotter.generateSummaries(combnDf)
  plotter.generatePlots(combnDf, resDfType)
  return(NULL)
  
}

