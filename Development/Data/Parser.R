
setClass("Parser", 
	representation(importer="Importer"))

Parser.parse = function(dat, namesMods, snrdbRange){
	
	out = dat
	out$cl = rep(0, nrow(dat))
	for(i in 1:length(namesMods)){
		idx = grep(namesMods[i], out$inf, ignore.case=T)
		out$cl[idx] = i
	}
	out$cl = as.factor(out$cl)
	out = out[,-match("inf", names(out))]
	
	out = subset(out, snrdB >= snrdbRange[1] & 
					snrdB <= snrdbRange[2])
	
	return(out)

}	

setGeneric("importParse", function(.Object){
	standardGeneric("importParse")})
		
setMethod("importParse", "Parser", function(.Object){
	importer = new("Importer")
	importer = import(importer)	
	.Object@importer = importer

	datTrn = importer@datTrn
	datTest = importer@datTest
	importSettings = importer@importSettings
	namesMods = importSettings@namesMods
	snrdbRange = importSettings@snrdbRange
	datTrn = Parser.parse(datTrn, namesMods, snrdbRange)
	datTest = Parser.parse(datTest, namesMods, snrdbRange)
	
	.Object@importer@datTrn = datTrn
	.Object@importer@datTest = datTest
	return(.Object)
	
})
	
	
	