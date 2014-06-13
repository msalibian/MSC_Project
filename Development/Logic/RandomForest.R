
setClass("RandomForest", 
	representation(ntree="numeric", mtry="numeric", fit="ANY", 
		pSel="numeric", nodesize="numeric"), 
	prototype=prototype(nodesize=20),
	contains="Model")
	
setMethod("predSel", "RandomForest", function(.Object, predsToSel){
	datTrn = .Object@datTrn
	fm = formula(paste0("cl~", paste(predsToSel, collapse="+")))
	#handle the case where one or more response values are empty
	#meaning it doesn't match what's expected of the factor
	if(length(unique(datTrn$cl)) < length(levels(datTrn$cl))){
		datTrn$cl = factor(datTrn$cl)
	}
	fit = randomForest(fm, datTrn, ntree=.Object@ntree, 
					mtry=.Object@mtry, nodesize=.Object@nodesize, 
					keep.forest=F)
	importanceDf = data.frame(fit$importance)
	importanceDf = importanceDf[order(importanceDf$MeanDecreaseGini,
									decreasing=T),,drop=F]
	predsSelected = row.names(importanceDf)[1:round(nrow(importanceDf)*(.Object@pSel))]
	return(predsSelected)
})
	
setMethod("predSelXk", "RandomForest", function(.Object){
	
	namesFeatures = .Object@namesFeatures
	idxXk = grep("^Xk", namesFeatures)
	idxOthers = which(!((1:length(namesFeatures))%in%idxXk))
	namesXk = namesFeatures[idxXk]
	namesOthers = namesFeatures[idxOthers]
	xkSelected = predSel(.Object, namesXk)
	predsToSel = c(namesOthers, xkSelected)
	out =	predSel(.Object, predsToSel)
	return(out)
})
	
setMethod("fitTrain", "RandomForest", function(.Object){
	predsSelected = .Object@predsSelected
	fm = formula(paste0("cl~", paste(predsSelected, collapse="+")))
	datTrn = .Object@datTrn
	if(length(unique(datTrn$cl)) < length(levels(datTrn$cl))){
		datTrn$cl = factor(datTrn$cl)
	}
	fit = randomForest(fm, datTrn, ntree=.Object@ntree, 
					mtry=.Object@mtry, keep.forest=T)
	.Object@fit = fit
	return(.Object)
})

setMethod("predTest", "RandomForest", function(.Object){
	fit = .Object@fit
	if(length(fit) == 0){
		stop("error in predTest for RandomForest. fit is missing")
	}
	pr = predict(fit, newdata=.Object@datTest)
	return(pr)
})

setMethod("modelProcess", "RandomForest", function(.Object){
	#.Object = modelObj
	if(length(.Object@ntree) == 0){
		.Object@ntree = 500
	}
	if(length(.Object@mtry) == 0){
		.Object@mtry = 12
	}
	if(length(.Object@pSel) == 0){
		.Object@pSel = .35
	}
	print(.Object@ntree); print(.Object@mtry); print(.Object@pSel);
	#obj = new("RandomForest", datTrn=.Object@datTrn, 
	#				datTest=.Object@datTest, namesFeatures=.Object@namesFeatures, 
	#				ntree=ntree, mtry=mtry, pSel=pSel, nodesize=nodesize)
	obj = modelProcessGeneric(.Object)
	return(obj)
})	
	
setMethod("genieProcess", "RandomForest", function(.Object){
	#.Object = modelObj
	if(length(.Object@ntree) == 0){
		.Object@ntree = 500
	}
	if(length(.Object@mtry) == 0){
		.Object@mtry = 12
	}
	if(length(.Object@pSel) == 0){
		.Object@pSel = .35
	}
	print(.Object@ntree); print(.Object@mtry); print(.Object@pSel);
	#obj = new("RandomForest", datTrn=.Object@datTrn, 
	#				datTest=.Object@datTest, namesFeatures=.Object@namesFeatures, 
	#				ntree=.Object@ntree, mtry=.Object@mtry, pSel=.Object@pSel, 
	#				nodesize=.Object@nodesize)
	obj = genieProcessGeneric(.Object)
	return(obj)
})	

setMethod("xkChosenProcess", "RandomForest", function(.Object){
	#.Object = modelObj
	if(length(.Object@ntree) == 0){
		.Object@ntree = 500
	}
	if(length(.Object@mtry) == 0){
		.Object@mtry = 12
	}
	if(length(.Object@pSel) == 0){
		.Object@pSel = .35
	}	
	print(.Object@ntree); print(.Object@mtry); print(.Object@pSel);
	#obj = new("RandomForest", datTrn=.Object@datTrn, 
	#				datTest=.Object@datTest, namesFeatures=.Object@namesFeatures, 
	#				ntree=ntree, mtry=mtry, pSel=pSel, nodesize=nodesize)
	obj = xkChosenProcessGeneric(.Object)
	return(obj)
})
	
	
	
	