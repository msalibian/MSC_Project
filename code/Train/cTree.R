
cTree.fitTrain = function(datTrn, datTest, namesFeatures){
	
	fm = formula(paste0("cl~", paste(namesFeatures, collapse="+")))
	# parms uses information gain
	# cp refers to complexity parameter
	fit = rpart(fm, data=datTrn, method="class", control=list("cp"=.005), 
					parms=list("split"="information"))
	
	# check tree doesn't use cl or snrdb just in case
	if(any(c("cl","snrdB") %in% names(fit$ordered))){
		stop("TreeSimple fit used cl or snrdB")
	}
	# pruning, determines optimal tree based on cp
	cp = fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"]
	fit = prune(fit, cp=cp)
	return(fit)
	
}

cTree.predTest = function(datTest, fit){
	
	if(length(fit) == 0){
		stop("error in predTest for TreeSimple. fit is missing")
	}
	out = predict(fit, newdata=datTest, type="class")
	return(out)
	
}

cTree.modelProcess = function(datTrn, datTest, namesFeatures){
	
	fit = cTree.fitTrain(datTrn, datTest, namesFeatures)
	pr = cTree.predTest(datTest, fit=fit)
	resDf = cbind(datTest[,c("snrdB","cl")], pr)
	return(resDf)
	
}




