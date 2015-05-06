% Removes outliers from an array of values based on the specifications of 
% boxplots.
% 
% Parameters
% ----------
% x : array of numeric values
% 
% Returns
% -------
% out : indexes of x that are not outliers
%
function out = outlier_filter(x)
	
	th_up = quantile(x,.75) + 1.5*iqr(x);
	th_low = quantile(x,.25) - 1.5*iqr(x);
	
	keep = find(x > th_low & x < th_up); 
	out = keep;
	
end	
	

