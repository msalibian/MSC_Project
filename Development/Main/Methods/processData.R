
processData = function(){
	
	namesDat = readNamesDat("Data/HeaderNames/namesDat.txt")
	namesModsAll = c("ook", "bpsk", "oqpsk", "bfskA", "bfskB", "bfskR2", "noise")

	N = 512
	P = 400
	snrdbRange = c(-28, 12)
	nX = 145
	P2 = 500 #test set

	datTrn = buildDat(namesDat, namesModsAll, "Data/Mods", N, P, snrdbRange, nX)
	datTest = buildDat(namesDat, namesModsAll, "Data/Mods", N, P2, snrdbRange, nX)
	
	inList2env = list(namesDat, namesModsAll, N, P, snrdbRange, nX, P2, 
		datTrn, datTest)
	names(inList2env) = c("namesDat", "namesModsAll", "N", "P", "snrdbRange", "nX", "P2", 
		"datTrn", "datTest")
	list2env(inList2env, envir=parent.frame())
	
	#print(parent.frame())
	
	return()
	
}	

