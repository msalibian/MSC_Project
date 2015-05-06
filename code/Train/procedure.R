# Procedure to train the classification tree and random forest on the 
# training data, and then predicts the testing data similar to 
# the FBT in mainFbTree.m the output data matrix is similar to the FBT 
# (see mainFbTree.m for resDf structure).
#
# This function takes in different parameters to specify whether the 
# additional features are included or not in training CT and RF. This 
# specification is based on experiment 1 and 2 as described in the 
# manuscript. 
#
# Parameters
# ----------
# k : parameter to indicate whether to include additional features in the fit
#     k="k" implies include 
# model : parameter to indicate CT or RF fit
# datTrn : training data
# datTest : testing data
#
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
	
	outf = "data//Fitted//"
	if(model == "cTree"){
		resDf = cTree.modelProcess(datTrn, datTest, namesFeatures)
		outf = paste0(outf, "cTree//cTree_", k, ".txt")
	} else if(model == "rForest") {
		resDf = rForest.modelProcess(datTrn, datTest, namesFeatures)
		outf = paste0(outf, "rForest//rForest_", k, ".txt")
	} else {
    resDf = ctApproxRf.modelProcess(datTest, namesFeatures)
    outf = paste0(outf, "ctApproxRf//ctApproxRf_", k, ".txt")
	}
	
	write.table(resDf, outf, sep=",", row.names=F, col.names=T)
}


