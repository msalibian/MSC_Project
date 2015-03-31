
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

plotter.aggregate = function(resDf){
  
  out = ddply(resDf, .(snrdB), .fun=summarize, "sr"=mean(res))
  return(out)

}

plotter.summarize = function(xCombnDf){
  
  resDf = plotter.readFile(xCombnDf)
  resDfType = plotter.aggregate(resDf)
  # set row names to NULL, this allows to combine with another dataframe
  row.names(xCombnDf) = NULL
  out = data.frame(xCombnDf, resDfType)
  return(out)
  
}

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
                "fbTree"="Feature-Based Tree")
  out$processCombn = revalue(out$processCombn, hashTable)
  return(out)
}

plotter.plot = function(ggdata){
  
  ggdata = plotter.parseLegend(ggdata)
# titleStr = plotter.parseTitle(ggdata)
  xBreaks = seq(min(ggdata$snrdB), max(ggdata$snrdB), by=5)
  yBreaks = seq(.1, 1, by=.1)
	colours1 = brewer.pal(n=9, "Greys")[9]
	#colours1 = c(colours1, brewer.pal(n=9, "Blues")[8])
	colours1 = c(colours1, brewer.pal(n=9, "Greens")[7])
  colours1 = c(colours1, brewer.pal(n=9, "Oranges")[4])
	gg = ggplot(ggdata, aes(x=snrdB, y=sr, 
          linetype=reorder(processCombn, desc(sr), mean), 
        color=reorder(processCombn, desc(sr), mean))) + 
        geom_line(size=1.3) + xlab("SNR (dB)") + 
        ylab("Success Rate") + 
        theme(axis.title=element_text(size=17), 
          axis.text=element_text(size=16), title=element_text(size=17),
          legend.text=element_text(size=16), 
          legend.title=element_text(size=16), 
          legend.position=c(.8, .15)) + 
        scale_color_manual(name="Models", values=colours1) +
        scale_linetype_manual(name="Models", values=c(1,3,4)) +
        scale_x_continuous(breaks=xBreaks) + 
        scale_y_continuous(breaks=yBreaks) + 
        labs(aesthetic="Models")
  
  k = unique(ggdata$k)
  outf = paste0("visualizations//pred-performance-", k, ".pdf")
  ggsave(outf, gg, width=8, height=6)
  
}

plotter.process = function(combnDf){
  
  resDfType = plotter.generateSummaries(combnDf)
  plotter.generatePlots(combnDf, resDfType)
  return(NULL)
  
}

