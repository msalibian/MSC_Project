
function thresholds = fbTree(datTrnList)

	threshold1 = calculateThreshold(datTrnList{2}, datTrnList{4}, 2, 5);
	threshold2 = calculateThreshold(datTrnList{2}, datTrnList{1}, 3, 5);
	threshold3 = calculateThreshold(datTrnList{4}, datTrnList{6}, 4, 10);
	threshold4 = calculateThreshold(datTrnList{5}, datTrnList{3}, 5, -2.5);
	threshold5 = calculateThreshold(datTrnList{4}, datTrnList{3}, 6, 10);	
	
	thresholds = [threshold1 threshold2 threshold3 threshold4 threshold5];
	
end






