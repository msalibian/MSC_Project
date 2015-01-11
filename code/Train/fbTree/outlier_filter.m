
function out = outlier_filter(x)
	
	th_up = quantile(x,.75) + 1.5*iqr(x);
	th_low = quantile(x,.25) - 1.5*iqr(x);
	
	keep = find(x > th_low & x < th_up); 
	out = keep;
	
end	
	
	


