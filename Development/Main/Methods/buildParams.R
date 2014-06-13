
buildParams = function(model=NULL){
	
	m = c("m", "nom") #for now, always include the 'm' features
	k = c("k", "nok") #additional features from other papers
	n = c("n", "non") #add or not add noise features
	nmod = c("nmod", "nonmod") #add or not add noise modulation data
	
	if(is.null(model)){
		model = c("TreeSimple")
	}
	
	combnDf = expand.grid("m"=m, "k"=k, "n"=n, "nmod"=nmod, "model"=model)

	filt1 = with(combnDf, which(n=="n" & nmod=="nonmod"))
	filt2 = with(combnDf, which(m=="nom" & k=="nok"))
	
	combnDf = combnDf[-c(filt1, filt2),]
	
	inList2env = list(combnDf)
	names(inList2env) = "combnDf"
	list2env(inList2env, envir=parent.frame())
	
	#combnDf = subset(combnDf, !((n=="non"&nmod=="nmod")|(n=="n"&nmod=="nonmod")))

	return()
	
}


