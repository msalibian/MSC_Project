
setClass("Importer", 
	representation(importSettings="ImportWrapper", datTrn="data.frame", 
	datTest="data.frame"))

Importer.readData = function(infs, namesDf){
	fn = function(x, namesDf){
		out = read.table(x, header=F, sep=",", 
						col.names=namesDf)
		out = cbind(out, "inf"=x)
		return(out)
	}
	out = ldply(infs, .fun=fn, namesDf=namesDf)
	return(out)
}	

setGeneric("import", function(.Object){
	standardGeneric("import")})
	
setMethod("import", "Importer", function(.Object){
	
	objWrapper = new("ImportWrapper")
	settings = setupParams(objWrapper)
	infsTrn = settings@infsTrn
	infsTest = settings@infsTest
	namesDf = settings@namesDf
	datTrn = Importer.readData(infsTrn, namesDf)
	datTest = Importer.readData(infsTest, namesDf)
	
	.Object@importSettings = settings
	.Object@datTrn = datTrn
	.Object@datTest = datTest
	
	return(.Object)
	
})


	
	