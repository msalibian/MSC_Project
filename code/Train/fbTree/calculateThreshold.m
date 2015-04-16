% Computation of threshold between two modulations for a feature. The 
% threshold is chosen as the intersection of the two lines specified by 
% Xmin and Xmax. 
% The intersection is found by fitting a piece-wise linear interpolation 
% to Xmin and Xmax, and then finding the intersection of the two lines 
% by taking the difference and finding the root. 
%
% Parameters
% ----------
% Xmin : the modulation data specified to be used as the min line.
% Xmax : the modulation data specified to be used as the max line.
% p : position in columns of the data representing the feature. p=2
% corresponds to m1.
% init : starting position used to find the intersection.
%
% Returns
% -------
% threshold : value of the intersection.
% pp_min : piece-wise linear interpolation fit for Xmin.
% pp_max : piece-wise linear interpolation fit for Xmax.
%
function [threshold, pp_min, pp_max] = calculateThreshold(Xmin, Xmax, p, init)
    
	[Xmin_snrdB Xmin_m] = aggregate(Xmin(:,1), Xmin(:,p), @(x) min(x));
	Xmin_m = cell2mat(Xmin_m);
	Xmin1 = [Xmin_snrdB Xmin_m];
	
	[Xmax_snrdB Xmax_m] = aggregate(Xmax(:,1), Xmax(:,p), @(x) max(x));
	Xmax_m = cell2mat(Xmax_m);
	Xmax1 = [Xmax_snrdB Xmax_m];
	
	pp_min = interp1(Xmin1(:,1), Xmin1(:,2), 'linear', 'pp');
	pp_max = interp1(Xmax1(:,1), Xmax1(:,2), 'linear', 'pp');
	x_intersect = fzero(@(x) ppval(pp_min,x) - ppval(pp_max,x), init);
	threshold = ppval(pp_min, x_intersect);
	
end

