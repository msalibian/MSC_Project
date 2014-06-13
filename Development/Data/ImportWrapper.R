
setClass("ImportWrapper", 
	representation(namesDf="character", namesMods="character", 
	N="numeric", snrdbRange="numeric", nX="numeric", P="numeric", 
	P2="numeric", infsTrn="character", infsTest="character"))

setGeneric("setupParams", function(.Object){
	standardGeneric("setupParams")})
	
setMethod("setupParams", "ImportWrapper", function(.Object){
	
	path = "/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/HeaderNames/namesDat.txt"
	namesDf = read.table(path, header=F, stringsAsFactors=F)
	namesDf = namesDf[,1]
	namesMods = c("ook", "bpsk", "oqpsk", "bfskA", "bfskB", "bfskR2", "noise")
	
	N = 512
	snrdbRange = c(-25, 10)
	nX = 145
	P = 50
	P2 = 200
	root = "/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/Mods"
	inf_ptrnTrn = paste0("N", N, "_P", P, "_snrdB", snrdbRange[1], 
									":", snrdbRange[2], "_nX", nX)
	infsTrn = list.files(root, pattern=inf_ptrnTrn, recursive=T, full.names=T, 
							all.files=T)	
	infs_ptrnTest = paste0("N", N, "_P", P2, "_snrdB", snrdbRange[1], 
										":", snrdbRange[2], "_nX", nX)
	infsTest = list.files(root, pattern=infs_ptrnTest, recursive=T, full.names=T, 
							all.files=T)		
	
	out = new("ImportWrapper", namesDf=namesDf, namesMods=namesMods, 
					N=N, snrdbRange=snrdbRange, nX=nX, P=P, P2=P2, infsTrn=infsTrn, 
					infsTest=infsTest)
	return(out)

})


#setMethod("setupParamsTrn", "ImportWrapper", function(.Object){

	#set what parameter P for training data
	#this is to avoid having to modifying anything in "Importer" class
#	P = 400
#	out = setupParams(.Object, P=P)
#	return(out)
	
#})

#setMethod("setupParamsTest", "ImportWrapper", function(.Object){
	
#	P = 500
#	out = setupParams(.Object, P=P)
#	return(out)
	
#})
	

	
	