# Classification tree (CT) class which contains three methods that 
# trains CTs on the training data passed in, and predicts the input 
# test data set.

# CT fit to the training data.
# Parameters
# ----------
# datTrn : training data
# namesFeatures : features used to fit the CT
#
# Returns
# -------
# fit : classification tree fit object from rpart library
#
cTree.fitTrain = function(datTrn, namesFeatures){
  # constructs a formula to specify the model.
	fm = formula(paste0("cl~", paste(namesFeatures, collapse="+")))
	# parms uses information gain (entropy objective function)
	# cp refers to a complexity parameter used for pruning the tree
	fit = rpart(fm, data=datTrn, method="class", control=list("cp"=.005), 
					parms=list("split"="information"))
	
	# check that the model doesn't use cl or snrdb as features
	if(any(c("cl","snrdB") %in% names(fit$ordered))){
		stop("TreeSimple fit used cl or snrdB")
	}
	# Prune the tree
	cp = fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"]
	fit = prune(fit, cp=cp)
	return(fit)
}

# Makes predictions on the fitted CT object using the testing data.
#
# Parameters
# ----------
# datTest : training data
# fit : classification fit object from fitting a CT from cTree.fitTrain
# 
# Returns
# -------
# out : vector of class predictions
#
cTree.predTest = function(datTest, fit){
	if(length(fit) == 0){
		stop("error in predTest for TreeSimple. fit is missing")
	}
	out = predict(fit, newdata=datTest, type="class")
	return(out)
}

# Calls the methods to train on the training data, and make predictions 
# on the testing data. The namesFeatures allows the CT to specify 
# whether to include all the features of just m1 to m5. 
#
# Parameters
# ----------
# datTrn : training data
# datTest : testing data
# namesFeatures : features used to fit the CT
#
# Returns
# -------
# resDf : data frame that contains the SNR, true modulation, predicted 
#         modulation for each row. This data frame is used to assess 
#         the predictive performance of each classifier. 
#
cTree.modelProcess = function(datTrn, datTest, namesFeatures){
	fit = cTree.fitTrain(datTrn, namesFeatures)
	pr = cTree.predTest(datTest, fit=fit)
	resDf = cbind(datTest[,c("snrdB","cl")], pr)
	return(resDf)
}


