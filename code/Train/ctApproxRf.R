# The approximation to the RF trees method (CT-Approx RF) class that contains 
# methods to load in fitted object.
# We have not yet provided the implementation to this method publicly.
# This script is similar to how we trained and predicted in the rForest.R and 
# cTree.R

ctApproxRf.predTest = function(datTest, fit) {
  if(length(fit) == 0) {
    stop("error in predTest for ctApproxRf. fit is missing")
  }
  out = predict(fit, newdata=datTest, type="class")
  return(out)
}

ctApproxRf.modelProcess = function(datTest, namesFeatures, pSel=NULL) {
  # let us assume that the fit is stored in a variable called d.50 
  # when we load in the fitted object from disk
  fit = d.50
  
  pr = ctApproxRf.predTest(datTest, fit=fit)
  resDf = cbind(datTest[,c("snrdB","cl")])
  return(resDf)
}
