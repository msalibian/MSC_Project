
setClass("ModelProcedure", 
	representation(paramGrid="ParamGrid", parser="Parser"))

ModelProcedure.mapFeatures = function(m, k, n, namesDat){
	
	mNames = switch(m, m=c("m1", "m2", "m3", "m4", "m5"), nom=c())
	nNames = switch(n, n=c("enull", "Qstat"), non=c())
	
	strXk = grep("^Xk", namesDat, value=T)
	
	kNames = switch(k, k=c("snrdbHat", "gammaMax", "gamma2", "gamma4", 
						"sigmaAa", "sigmaA", "sigmaAp", "sigmaDp", "mu42A", "CRR", 
						"CRI", "CII" , "CRRR", "CRRI", "CRII", "CIII",
						"CRRRR", "CRRRI", "CRRII", "CRIII", "CIIII", strXk), nok=c())
	
	out = c(mNames, kNames, nNames)
	return(out)
	
}

ModelProcedure.mapMods = function(nmod){
	
	nmodNames = switch(nmod, 
								nmod=c("ook", "bpsk", "oqpsk", "bfskA", "bfskB", "bfskR2", "noise"), 
								nonmod=c("ook", "bpsk", "oqpsk", "bfskA", "bfskB", "bfskR2"))
	return(nmodNames)
	
}

ModelProcedure.procedure = function(xCombnDf, parser){
	#xCombnDf = combnDf[7,]
	
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

	modelObj = new(model, datTrn=datTrn, datTest=datTest, namesFeatures=namesFeatures)
	
	#factory method pattern is apparently within the  
	#modelProcess, genieProcess, etc methods
	modelObjNormal = modelProcess(modelObj)
	modelObjGenie = genieProcess(modelObj)
	if(length(grep("^Xk", namesFeatures, value=T)) >= 1){
		modelObjXkChosen = xkChosenProcess(modelObj)
	}
	#...
	
	modelObjList = list("normal"=modelObjNormal, "genie"=modelObjGenie, 
									"xkChosen"=modelObjChosen)
	rootOutf = "/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/Fitted"
	for(i in 1:length(resDfList)){
		resDfStr = names(resDfList)[[i]]
		modelObjMethod = modelObjList[[i]]
		resDf = modelObjMethod@resDf
		outfPtrn = paste0("N", N, "_P", P, "_snrdB", snrdbRange[1], 
								":", snrdbRange[2], "_nF", length(namesFeatures))
		outf = paste0(rootOutf, model, "_", m, "_", n, "_", nmod, "_", 
						outfPtrn) 
		resDf = data.matrix(resDf)
		write.table(resDf, outf, sep=",", row.names=F, col.names=F)
	}
}
	
setGeneric("automate", function(.Object){
	standardGeneric("automate")})
	
setMethod("automate", "ModelProcedure", function(.Object){
	
	#.Object = modelProcedure
	
	paramGrid = .Object@paramGrid
	combnDf = paramGrid@combnDf
	parser = .Object@parser
	
	d_ply(combnDf, .(m, k, n, nmod, model), .fun=ModelProcedure.procedure, 
		parser=parser)
	
})
	


	
	