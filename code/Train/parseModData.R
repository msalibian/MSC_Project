
setwd("C://Users//Ken//Documents//GitHub//MSC_Project")

library(plyr)

inPath = "data//Modulation"
# The following correspond to 'P' in the paper.
sizeTrn = 50
sizeTest = 200

infsTrn = list.files(inPath, pattern=paste0("P", sizeTrn), full.names=T)
infsTest = list.files(inPath, pattern=paste0("P", sizeTest), full.names=T)

# list of column names in a text file
colNames = read.table("data//namesDat.txt", header=F, 
						stringsAsFactors=F)[,1]

readData = function(x, colNames){
	out = read.table(x, header=F, sep=",", col.names=colNames)
}

datTrn = ldply(infsTrn, .fun=readData, colNames=colNames)
datTest = ldply(infsTest, .fun=readData, colNames=colNames)

write.table(datTrn, file="data//datTrn.txt", sep=",")
write.table(datTest, file="data//datTest.txt", sep=",")




