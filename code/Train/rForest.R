
rForest.predSel = function(datTrn, namesFeatures, params){
	
	fm = formula(paste0("cl~", paste(namesFeatures, collapse="+")))
	#handle the case where one or more response values are empty
	#meaning it doesn't match what's expected of the factor
	if(length(unique(datTrn$cl)) < length(levels(datTrn$cl))){
		datTrn$cl = factor(datTrn$cl)
	}
	# uses 500 trees instead of 850
	# uses min leaf node size of 10
	# this speeds up computation, while keeping the difference negligible 
	#  since we are only interested in feature selection at this step
	fit = randomForest(fm, datTrn, nTree=400, keep.forest=F, nodesize=10)
	importanceDf = data.frame(fit$importance)
	importanceDf = importanceDf[order(importanceDf$MeanDecreaseGini,
																		decreasing=T),,drop=F]
	out = row.names(importanceDf)[1:round(nrow(importanceDf)*(params$pSel))]
	return(out)
	
}

rForest.fitTrain = function(datTrn, datTest, namesFeatures, params){
	
	fm = formula(paste0("cl~", paste(namesFeatures, collapse="+")))
	if(length(unique(datTrn$cl)) < length(levels(datTrn$cl))){
		datTrn$cl = factor(datTrn$cl)
	}
	# mtry parameter does not appear here, since we use the default
	# we always use ntree=850
	fit = randomForest(fm, datTrn, nTree=params$ntree)
	return(fit)

}

rForest.predTest = function(datTest, fit){
	
	if(length(fit) == 0){
		stop("error in predTest for RandomForest. fit is missing")
	}
	out = predict(fit, newdata=datTest)
	return(out)

}

rForest.modelProcess = function(datTrn, datTest, namesFeatures){
	
	params = list()
	params$ntree = 850
	if(length(namesFeatures) < 10){
    params$pSel = 1
	} else {
    params$pSel = .4
	}
  namesFeatures = rForest.predSel(datTrn, namesFeatures, params)
	fit = rForest.fitTrain(datTrn, datTest, namesFeatures, params)
	pr = rForest.predTest(datTest, fit=fit)
	resDf = cbind(datTest[,c("snrdB","cl")], pr)
	return(resDf)
	
}


