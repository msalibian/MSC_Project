% Removal of outliers from the data using boxplot specification of
% outliers. The boxplot specification of outliers is described as follows:
% Let Q1 and Q3 be the 25th and 75th percentile of the data respectively, 
% and let the interquartile range (IQR) be equal to Q3 - Q1. The outliers 
% of the data are any values less than Q1 - 1.5*IQR or greater than 
% Q3 + 1.5*IQR.
% See script outlier_filter.m for the implementation. 
%
% Parameters
% ----------
% dat_<modulation> : modulation training data.
%
% Returns
% -------
% dat_<modulation> : modulation training data with outliers removed.
%
function [dat_ook, dat_bpsk, dat_oqpsk, dat_bfskA, ...
dat_bfskB, dat_bfskR2] = whisker_fn(dat_ook, dat_bpsk, ...
dat_oqpsk, dat_bfskA, dat_bfskB, dat_bfskR2)

	% filter ook data for m2
	dat_ook = whisker_wrapper_fn(dat_ook, 3);
	% filter bfskA data for m1
	dat_bfskA = whisker_wrapper_fn(dat_bfskA, 2);
	% filter bfskA data for m3
	dat_bfskA = whisker_wrapper_fn(dat_bfskA, 4);
		
end
	
	
	


