# Random Forest (RF) class which contains three methods that 
# trains RFs on the training data passed in, and predicts the 
# input testing data. 

# RF feature variable selection. This function is executed before fitting 
# the actual RF model to the data. This function fits a RF model 
# initially using a smaller number of trees and larger minimum leaf nodes. 
# The features are then ranked by variable importance of each feature 
# towards the RF model. The top 40% of features are chosen based on variable 
# importance (see rForest.cvOptSel function below for more detail).
#
# Parameters
# ----------
# datTrn : training data
# namesFeatures : features used to fit the CT
# params : additional parameters for the RF fit eg. number of trees
#
# Returns
# -------
# out : names of feature variable chosen by the selection
#
rForest.predSel = function(datTrn, namesFeatures, params){
	
	fm = formula(paste0("cl~", paste(namesFeatures, collapse="+")))
	#handles the case where one or more response values are empty
	#meaning it doesn't match what's expected of the factor
	if(length(unique(datTrn$cl)) < length(levels(datTrn$cl))){
		datTrn$cl = factor(datTrn$cl)
	}
	# uses 400 trees instead of 850
	# uses min leaf node size of 10
	# this speeds up computation, while the difference is negligible 
	# since we are only interested in feature selection at this step
	fit = randomForest(fm, datTrn, nTree=400, keep.forest=F, nodesize=10)
	
  # Ignore the following lines. The lines plots out the variable 
  # importance plot by calling the rForest.plotImportance function 
  # commented out at the bottom of this script.
	#if(length(namesFeatures) > 10){
  #  ggImp = rForest.plotImportance(fit)
  #  ggsave("visualizations//importance2.pdf", ggImp, width=8, height=8)
	#}
    
  importanceDf = data.frame(fit$importance)
	importanceDf = importanceDf[order(importanceDf$MeanDecreaseGini,
																		decreasing=T),,drop=F]
	out = row.names(importanceDf)[1:round(nrow(importanceDf)*(params$pSel))]
	return(out)
	
}

# RF fit to the training data.
#
# Parameters
# ----------
# datTrn : training data
# namesFeatures : features used to fit the CT
# params : additional parameters for the RF fit eg. number of trees
#
# Returns
# -------
# fit : random forest fit object from randomForest library
#
rForest.fitTrain = function(datTrn, namesFeatures, params){
	
	fm = formula(paste0("cl~", paste(namesFeatures, collapse="+")))
	if(length(unique(datTrn$cl)) < length(levels(datTrn$cl))){
		datTrn$cl = factor(datTrn$cl)
	}
	# mtry parameter does not appear here, since we use the default
	# we always use ntree=850
	fit = randomForest(fm, datTrn, nTree=params$ntree)
	return(fit)

}

# Makes predictions on the fitted RF object using the testing data.
#
# Parameters
# ----------
# datTest : training data
# fit : random forest fit object from fitting a RF from rForest.fitTrain
# 
# Returns
# -------
# out : vector of class predictions
#
rForest.predTest = function(datTest, fit){
	
	if(length(fit) == 0){
		stop("error in predTest for RandomForest. fit is missing")
	}
	out = predict(fit, newdata=datTest)
	return(out)

}

# Calls the methods to feature select and train on the training data, and 
# make predictions on the testing data. The namesFeatures allows the RF to 
# specify whether to include all the features of just m1 to m5. The 
# pSel argument can be passed which specifies the proportion of features 
# to select in the feature selection step. The value is defaulted to 
# 40% as described in rForest.predSel function.
#
# Parameters
# ----------
# datTrn : training data
# datTest : testing data
# namesFeatures : features used to fit the CT
# pSel : proportion of features to select in the feature selection step
#
# Returns
# -------
# resDf : data frame that contains the SNR, true modulation, predicted 
#         modulation for each row. This data frame is used to assess 
#         the predictive performance of each classifier. 
#
rForest.modelProcess = function(datTrn, datTest, namesFeatures, pSel=NULL){
	
	params = list()
	params$ntree = 850
  params$pSel = pSel
	if(is.null(params$pSel)){  
    if(length(namesFeatures) < 10){
      params$pSel = 1
	  } else {
      params$pSel = .4
	  }
	}
  namesFeatures = rForest.predSel(datTrn, namesFeatures, params)
  fit = rForest.fitTrain(datTrn, namesFeatures, params)
	pr = rForest.predTest(datTest, fit=fit)
	resDf = cbind(datTest[,c("snrdB","cl")], pr)
	return(resDf)
	
}

# 10-fold cross-validation on success rates of predictions to determine 
# the proportion of features to select at the feature variable selection 
# stage of RF. The 40% criteria is optimal and was chosen based on the 
# cross-validation performances. We also tried 14.5%, 
# 50%, 60%, 70%, and 100%. 
#
# We did not provide an executable script for this function, but it 
# can be easily refactored to a main script and ran there or run 
# using the interactive console of R.
# See the file cv-on-featSel.txt for an example of the output.
#
# Parameters
# ----------
# datTrn : training data
# namesFeatures : features used to fit the CT
# 
rForest.cvOptSel = function(datTrn, namesFeatures){

  require(cvTools)
  pSels = c(.4, .5, .6, .7)
  # pSels = c(.145, 1)
  K = 10
  R = 3
  outCvFolds = cvFolds(nrow(datTrn), K=K, R=R)
  cvFoldsAll = data.frame(outCvFolds$subset)
  cvFoldsAll$fold = outCvFolds$which
  
  srP = c()
  for(p in 1:length(pSels)){
    pSel = pSels[p]
    srR = c()
    for(r in 1:R){
      cvfolds = cvFoldsAll[,c(r,R+1)]
      srs = c()
      for(f in 1:K){
        idxTestFold = subset(cvfolds, fold==f)[,1]
        datTestFold = datTrn[idxTestFold,]  
        datTrnFold = datTrn[!(1:nrow(datTrn))%in%idxTestFold,]
        resDf = rForest.modelProcess(datTrnFold, datTestFold, namesFeatures, pSel)
        srs[f] = mean(resDf$cl == resDf$pr) 
      }
      srR[r] = mean(srs)
    }
    srP[p] = mean(srR)
  }
  out = data.frame(pSel=pSels, sr=srP)
  write.table(out, "cv-on-featSel.txt", sep=",", row.names=F, col.names=T)
  
}


# Ignore this function. This function plots the variable importance 
# of each feature variable contribution towards the RF fit.
# rForest.plotImportance = function(fit){
#   importanceMtx = fit$importance
#   # change Xk name to Rk
#   row.names(importanceMtx) = gsub("^Xk", "Rk", row.names(importanceMtx))
#   importanceDf = data.frame("feature"=row.names(importanceMtx),
#                             "importance"=c(importanceMtx))
#   importanceDf = importanceDf[order(importanceDf$importance, decreasing=T),]
#   n = round(.4*nrow(importanceDf))
#   #importanceDf = importanceDf[1:(n+5),]
#   importanceDf$threshold = factor(c(rep("top_40",n), rep("bottom_60",nrow(importanceDf)-n)))
#   xBreaks = importanceDf$feature
#   xBreaks = as.character(xBreaks[seq(1,length(xBreaks),by=4)])
#   gg = ggplot(importanceDf, aes(y=importance, x=reorder(feature,importance))) +
#     coord_flip() +
#     geom_point(size=3, aes(color=threshold)) + 
#     xlab("Features") +
#     ylab("Importance") +
#     scale_x_discrete(breaks=xBreaks) + 
#     scale_color_discrete(name="Threshold", 
#                          breaks=c("top_40","bottom_60"),labels=c("Top 40%","Bottom 60%")) +  
#     theme(axis.title=element_text(size=17), 
#           legend.text=element_text(size=14), 
#           legend.title=element_text(size=14), 
#           legend.position=c(.9, .4))
#   
#   return(gg)
# }



