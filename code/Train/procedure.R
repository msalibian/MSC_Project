
procedure = function(k, model, datTrn, datTest){
	
	# namesFeatures is a character vector of all features to be 
	#  included in the model
	if(k == "k"){
		# all features including m1,...,m5
		namesFeatures = names(datTrn)[-match(c("snrdB","cl"),names(datTrn))]	
	} else {
		# only m1,...,m5 features
		namesFeatures = c("m1", "m2", "m3", "m4", "m5")
	}
	
	outf = "data//Fitted"
	if(model == "cTree"){
		resDf = cTree.modelProcess(datTrn, datTest, namesFeatures)
		outf = paste0(outf, "cTree//cTree_", k, ".txt")
	} else {
		resDf = rForest.modelProcess(datTrn, datTest, namesFeatures)
		outf = paste0(outf, "rForest//rForest_", k, ".txt")
	}
	
	write.table(resDf, outf, sep=",", row.names=F, col.names=T)
	
}


