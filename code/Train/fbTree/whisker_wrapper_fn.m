% Outlier removal function refactored to remove outliers from corresponding
% training data sets and features.
% Calls the outlier_filter function.
% p corresponds to the column of the data
% p=2 is m1, p=3 is m2, and so on
%
% Parameters
% ----------
% dat : training data
% p : position in columns of dat of selected feature to filter
%
% Returns
% -------
% out : training data
%
function out = whisker_wrapper_fn(dat, p)

	snrdB_vec = unique(dat(:,1));
	out = [];
	for j = 1:length(snrdB_vec)
		idx_j = find(dat(:,1) == snrdB_vec(j));
		dat_j = dat(idx_j,:); 
		
		idx_j_new = outlier_filter(dat_j(:,p));
		dat_j_new = dat_j(idx_j_new,:);
		out = [out; dat_j_new];
	end
	
end	
	
	
	

