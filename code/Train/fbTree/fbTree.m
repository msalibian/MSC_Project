% Compututation of threshold using worst-case analysis specified in [5] 
% for each of the features m1 to m5.
% See calculateThreshold.m for the implementation.
%
% Parameters
% ----------
% datTrnList : list of training data sets for each of the six modulations.
%
% Returns
% -------
% thresholds : array of threshold values for each of the features.
%
function thresholds = fbTree(datTrnList)

    % Threshold 1 is obtained by finding the intersection between the 
    % min of BPSK and max of BFSK-A. Similarly, the worst-case analyses 
    % of the remaining thresholds are shown in fig 3 of [5]. 
	threshold1 = calculateThreshold(datTrnList{2}, datTrnList{4}, 2, 5);
	threshold2 = calculateThreshold(datTrnList{2}, datTrnList{1}, 3, 5);
	threshold3 = calculateThreshold(datTrnList{4}, datTrnList{6}, 4, 10);
	threshold4 = calculateThreshold(datTrnList{5}, datTrnList{3}, 5, -2.5);
	threshold5 = calculateThreshold(datTrnList{4}, datTrnList{3}, 6, 10);	
	
	thresholds = [threshold1 threshold2 threshold3 threshold4 threshold5];
	
end



