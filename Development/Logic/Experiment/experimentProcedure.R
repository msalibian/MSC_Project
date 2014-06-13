
evaluateRes = function(resDf){

	resDf = cbind(resDf, "res"=(resDf$cl == resDf$pr))
	out = ddply(resDf, .(snrdB), .fun=summarize, 
					"sr"=mean(res))
	out = mean(out$sr)
	
	return(out)
	
}

setGeneric("experimentProcedure", signature=".Object", 
	def = function(.Object, ...){
	standardGeneric("experimentProcedure")})

Experiment.setup = function(xCombnDf, parser){
	#xCombnDf = combnDfRf[1,]
	importer = parser@importer
	datTrn = importer@datTrn
	datTest = importer@datTest
		
	m = xCombnDf$m
	k = xCombnDf$k
	n = xCombnDf$n 
	nmod = xCombnDf$nmod
	model = as.character(xCombnDf$model)

	namesFeatures = ModelProcedure.mapFeatures(m, k, n, names(datTrn))
	namesMods = ModelProcedure.mapMods(nmod)	

	if(nmod == "nonmod"){
		datTrn = subset(datTrn, cl != 7)
		datTest = subset(datTest, cl !=7)
	}
	
	inList2env = list(datTrn, datTest, m, k, n, nmod, model, 
								namesFeatures, namesMods)
	names(inList2env) = c("datTrn", "datTest", "m", "k", 
		"n", "nmod", "model", "namesFeatures", "namesMods")
	list2env(inList2env, envir=parent.frame())	
	return("setup success")
}
	
setMethod("experimentProcedure", "RandomForest", 
	function(.Object, xCombnDf, parser){
		
	Experiment.setup(xCombnDf=xCombnDf, parser=parser)

	ntree = c(250, 500, 750)
	mtry = c(8, 12, 16)
	pSel = c(.3, .4, .5)
	
	modelGrid = expand.grid("ntree"=ntree, "mtry"=mtry, "pSel"=pSel)
		
	if(model != "RandomForest"){
		stop("model is not correct")
	}
	
	tempFun = function(xModelGrid, model){
		#xModelGrid = modelGrid[1,]
		ntree = xModelGrid$ntree
		mtry = xModelGrid$mtry
		pSel = xModelGrid$pSel
		modelObj = new(model, datTrn=datTrn, datTest=datTest, 
								namesFeatures=namesFeatures, ntree=ntree, 
								mtry=mtry, pSel=pSel, nodesize=20)
		pNormal = modelProcess(modelObj)
		resDfNormal = pNormal@resDf
		pGenie = genieProcess(modelObj)
		resDfGenie = pGenie@resDf					
		pXkChosen = xkChosenProcess(modelObj)
		resDfXkChosen = pXkChosen@resDf
		
		resDfList = list(resDfNormal, resDfGenie, resDfXkChosen)
		names(resDfList) = c("resDfNormal", "resDfGenie", "resDfXkChosen")
		out = sapply(resDfList, FUN=evaluateRes)
		
	}	
	resDfModel = ddply(modelGrid, .(ntree, mtry, pSel), 
								.fun=tempFun, model=model)
	return(resDfModel)
})		
		
		
	


	
	
	