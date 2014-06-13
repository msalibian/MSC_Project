
setClass("Model", representation("VIRTUAL", 
	datTrn="data.frame", namesFeatures="character", datTest="data.frame", 
	resDf="data.frame", fit="ANY", predsSelected="character"))

setGeneric("predSel", signature=".Object", 
	def = function(.Object, ...){
	standardGeneric("predSel")
})

setGeneric("predSelXk", signature=".Object", 
	def = function(.Object, ...){
	standardGeneric("predSelXk")
})
	
setGeneric("fitTrain", signature=".Object", 
	def = function(.Object){
	standardGeneric("fitTrain")
})

setGeneric("fitGenie", signature=".Object", 
	def = function(.Object, ...){
	standardGeneric("fitGenie")
})

setGeneric("predTest", signature=".Object", 
	def = function(.Object){
	standardGeneric("predTest")
})

Model.catchOneCl = function(.Object){
	datTrn = .Object@datTrn
	datTest = .Object@datTest
	if(length(unique(datTrn$cl)) == 1){
		onlyCl = unique(datTrn$cl)
		pr = rep(onlyCl, nrow(datTest))
		resDf = cbind(datTest[,c("snrdB","cl")], pr)
		.Object@resDf = resDf
		return(.Object)
	} else {
		return(F)
	}	
}
	
setGeneric("modelProcess", signature=".Object", 
	def = function(.Object, ...){
	standardGeneric("modelProcess")
})

modelProcessGeneric = function(.Object){
	#.Object = obj
	#.Object = y
	
	#catch one class only in training data exception
	obj = Model.catchOneCl(.Object)
	if(class(obj) != "logical"){
		print("there is a data with only one class")
		return(obj)
	}
	predsToSel = .Object@namesFeatures
	predsSelected = predSel(.Object, predsToSel)
	.Object@predsSelected = predsSelected
	.Object = fitTrain(.Object)
#	fit = .Object@fit
	pred = predTest(.Object)
	datTest = .Object@datTest
	resDf = cbind(datTest[,c("snrdB","cl")], pred)
	.Object@resDf = resDf
	return(.Object)
}

setGeneric("genieProcess", signature=".Object", 
	def = function(.Object, ...){
	standardGeneric("genieProcess")
})

addGenieP = function(dat){

	genieDf = dat
	snrdbHat = genieDf$snrdbHat
	snrdbHat = snrdbHat[which(snrdbHat > -49.99)]
	breaks = c(-1000, quantile(snrdbHat,probs=seq(0,1,.1)))
	labels = paste0("p", 0:(length(breaks)-2))
	genieDf$genieP = cut(genieDf$snrdbHat, breaks=breaks, labels=labels, 
											include.lowest=T)
	return(genieDf)

}

genieProcessGeneric = function(.Object){
	#.Object = obj
	datTrn = .Object@datTrn
	datTrn = addGenieP(datTrn)
	datTest = .Object@datTest
	datTest = addGenieP(datTest)
	genieP = unique(datTrn$genieP)
	namesFeatures = .Object@namesFeatures
	#remove snrdbHat feature, if snrdbHat already removed return 
	#original namesFeatures. (the ...+5 allows R to handle this case)
	namesFeatures = namesFeatures[-match("snrdbHat", namesFeatures, 
										nomatch=length(namesFeatures)+5)]
	modelName = as.character(class(.Object))
	
	genieProcessHelper = function(p, .Object, datTrn, datTest, namesFeatures, modelName){
		genieTrn = subset(datTrn, genieP==p)
		genieTest = subset(datTest, genieP==p)
		y = .Object
		y@datTrn = genieTrn
		y@datTest = genieTest
		y@namesFeatures = namesFeatures
		#y = new(modelName, datTrn=genieTrn, datTest=genieTest, 
		#			namesFeatures=namesFeatures)		
		obj = modelProcess(y)
		out = obj@resDf
		return(out)
	}	
	resDf = ldply(genieP, .fun=genieProcessHelper, .Object=.Object,
						datTrn=datTrn, datTest=datTest, 
						namesFeatures=namesFeatures, modelName=modelName)
	.Object@resDf = resDf
	return(.Object)
}

setGeneric("xkChosenProcess", function(.Object, ...){
	standardGeneric("xkChosenProcess")})

xkChosenProcessGeneric = function(.Object){
	#.Object = modelObj

	obj = Model.catchOneCl(.Object)
	if(class(obj) != "logical"){
		print("there is a data with only one class")
		return(obj)
	}	
	predsToSel = .Object@namesFeatures
	predsSelected = predSelXk(.Object)
	.Object@predsSelected = predsSelected
	.Object = fitTrain(.Object)
	fit = .Object@fit
	pred = predTest(.Object)
	datTest = .Object@datTest
	resDf = cbind(datTest[,c("snrdB","cl")], pred)
	.Object@resDf = resDf
	return(.Object)

}


