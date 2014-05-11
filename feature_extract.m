
function [m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2)
	N = length(xn);
	%dft to get frequency domain representation
	%Xk = fft(xn);
	Xk_tmp = fft(xn);
	Xk = Xk_tmp(1:ceil(N/2));
	
	%calculate absolute of Xk
	Xk_abs = abs(Xk);
	%frequency index. Not the actual frequency
	k = (1:ceil(N/2))';
	
	%obtain analytical representation of x[n]
	%calculate analytical representation of x[n]
	an = hilbert(xn);
	%calculate absolute value of an
	an_abs = abs(an);
	%calculate mean value of an_abs
	ma = mean(an_abs);
	%calculate normalized absolute anlytical signal
	an_abs_norm = an_abs/ma;
	%calculate dtft of an_abs_norm
	Ak = fft(an_abs_norm);
	
	%pre-specified frequency index for m1 and m2
	Ak_abs = abs(Ak);
	m1 = max(Ak_abs(k1)) + max(Ak_abs(k2));
	m2 = max(Ak_abs(k2))/max(Ak_abs(k1));
	%calculate index of k3, keep indexes of all maximums
	%k3_idx = find(Xk_abs == max(Xk_abs));
	%choose max with smallest index if there are multiple
	%maximums
	%k3 = min(k3_idx);
	[dummy,k3_idx] = max(Xk_abs);
	k3 = min(k3_idx);
	Xk_abs_k4 = Xk_abs;
	Xk_abs_k4([max(1,k3-3):min(k3+3,ceil(N/2))]) = -1;
	
	%make temporary vector to search for k4
	%Xk_abs_k4 = Xk_abs;
	%find indexes with difference within 3 of all indexes
	%found from k3_idx
	%k4_idx = arrayfun(@(x) (x-3:x+3), k3_idx, ... 
	%'UniformOutput', false);
	%k4_idx = arrayfun(@(x) (x-4:x+4), k3_idx, ... 
	%'UniformOutput', false);
	%converts compact array structure to matrix format
	%k4_idx = cell2mat(k4_idx);
	%converts matrix to vector format
	%k4_idx = k4_idx(:);
	%remove any elements in k4_idx <= 0
	%k4_idx(find(k4_idx <= 0)) = [];
	%sets indexes differences three to zero to avoid 
	%selection
	%Xk_abs_k4(k4_idx) = 0;
	[temp, k4_idx] = max(Xk_abs_k4);
	k4 = min(k4_idx);
	
	m3 = Xk_abs(k4)/Xk_abs(k3);
	m4 = floor((k3+k4-1)/2);
	%temp index array #1 for m5
	%idx1_m5 = (m4-B2/2):(m4+B2/2);
	%temp index array #1 keep only positives
	%idx1_m5(idx1_m5 <= 0) = [];
	%temp index array #2
	%idx2_m5 = (m4-B1/2):(m4+B1/2);
	%temp index array #2 keep only positives
	%idx2_m5(idx2_m5 <= 0) = [];
	idx1_m5 = max(1,(m4+1-B2/2)):min((m4+1+B2/2),ceil(N/2));
	idx2_m5 = max(1,(m4+1-B1/2)):min((m4+1+B1/2),ceil(N/2));
	m5 = sum(Xk_abs(idx1_m5))/sum(Xk_abs(idx2_m5));
end	
		
		
		