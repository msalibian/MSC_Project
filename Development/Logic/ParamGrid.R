
setClass("ParamGrid", 
	representation(models="character", combnDf="data.frame"))
	
setGeneric("buildParams", function(.Object){
	standardGeneric("buildParams")})

setMethod("buildParams", "ParamGrid", function(.Object){
	
	m = c("m", "nom") #for now, always include the 'm' features
	k = c("k", "nok") #additional features from other papers
	n = c("n", "non") #add or not add noise features
	nmod = c("nmod", "nonmod") #add or not add noise modulation data
	
	models = .Object@models
	if(length(models) == 0){
		models = c("TreeSimple", "RandomForest")
	}
	
	combnDf = expand.grid("m"=m, "k"=k, "n"=n, "nmod"=nmod, "model"=models)

	filt1 = with(combnDf, which(n=="n" & nmod=="nonmod"))
	filt2 = with(combnDf, which(m=="nom" & k=="nok"))
	filt3 = with(combnDf, which(n=="non" & nmod=="nmod"))
	
	combnDf = combnDf[-c(filt1, filt2, filt3),]
	.Object@combnDf = combnDf
	
	return(.Object)

})



