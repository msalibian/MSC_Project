
#tells the formal (S4) class system that you'd like to treat 
#an object with a class attribute "rpart" as an S4 class
#setOldClass("rpart")

#fit="ANY" allows you to use an general object reference

setClass("TreeSimple", 
	representation(method="character", 
		parms="list", control="list"), 
	contains="Model", 
	prototype=prototype(method="class", 
		parms=list("split"="information"), 
		control=list("cp"=.005)))
		
setMethod("predSel", "TreeSimple", function(.Object, predsToSel){
	datTrn = .Object@datTrn
	#There is no predictor selection for TreeSimple Model
	return(predsToSel)
})

setMethod("predSelXk", "TreeSimple", function(.Object){
	
	namesFeatures = .Object@namesFeatures
	idxXk = grep("^Xk", namesFeatures)
	idxOthers = which(!((1:length(namesFeatures))%in%idxXk))
	#features for Xk
	namesXk = namesFeatures[idxXk]
	#features not Xk
	namesOthers = namesFeatures[idxOthers]
	xkSelected = predSel(.Object, namesXk)
	predsToSel = c(namesOthers, xkSelected)
	out =	predSel(.Object, predsToSel)
	return(out)
})
	
setMethod("fitTrain", "TreeSimple", function(.Object){
	predsSelected = .Object@predsSelected
	fm = formula(paste0("cl~", paste(predsSelected, collapse="+")))
	datTrn = .Object@datTrn
	method = .Object@method
	parms = .Object@parms
	control = .Object@control
	fit = rpart(fm, data=datTrn, method=method, 
					parms=parms, control=control)
	cp = fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"]
	fit = prune(fit, cp=cp)
	.Object@fit = fit
	return(.Object)
})
	
setMethod("predTest", "TreeSimple", function(.Object){
	fit = .Object@fit
	if(length(fit) == 0){
		stop("error in predTest for TreeSimple. fit is missing")
	}
	pr = predict(fit, newdata=.Object@datTest, type=.Object@method)
	return(pr)
})
	
setMethod("modelProcess", "TreeSimple", function(.Object){
	#.Object = modelObj
	#need to change default fit parameters? method, parms, control?
	.Object = modelProcessGeneric(.Object)
	return(.Object)
})

setMethod("genieProcess", "TreeSimple", function(.Object){
	.Object = genieProcessGeneric(.Object)
	return(.Object)
})
	
setMethod("xkChosenProcess", "TreeSimple", function(.Object){
	.Object = xkChosenProcessGeneric(.Object)
	return(.Object)
})



	

		
		