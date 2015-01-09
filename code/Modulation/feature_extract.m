
function out = feature_extract(xn, k1, k2, B1, B2, nn)
	N = length(xn);
	
	if exist('nn', 'var')
		% standard deviation of noise
        sd_nn = std(nn);
		% small amount of noise to add to noise power estimate
        ep_nn = .05*sd_nn*randn(length(nn),1);
		% We are required to estimate the power of the noise 
        %  in real-time. However, for our simulations, we 
        %  add some error as a proxy to the 
        %  estimation error in estimating the noise in real-time.
        s2_n = (1/N)*sum((nn+ep_nn).^2);
		% energy
        e = (1/N)*sum(xn.^2);
		% energy normalized by variance
        enull = e/s2_n;
		% snr estimate (included as feature)
        snrdB_hat = 10*log10((e-s2_n)/s2_n);
		%if snrdB_hat is complex number due to e-s2_n negative
		if ~isreal(snrdB_hat) | isinf(snrdB_hat)
			snrdB_hat = -200;
		end	
	else
		e = 0;
		snrdB_hat = 0;
    end
	
	% dft to get frequency domain representation
	Xk_tmp = fft(xn);
	Xk = Xk_tmp(1:ceil(N/2));
	
	% calculate absolute of Xk
	Xk_abs = abs(Xk);
	% frequency index. Not the actual frequency
	k = (1:ceil(N/2))';
	
	% obtain analytical representation of x[n]
	% calculate analytical representation of x[n]
	an = hilbert(xn);
	% calculate absolute value of an
	% according to sources, this is also the instantaneous amplitude
	an_abs = abs(an);
	% calculate mean value of an_abs
	ma = mean(an_abs);
	% calculate normalized absolute anlytical signal
	an_abs_norm = an_abs/ma;
	% calculate dtft of an_abs_norm
	Ak_tmp = fft(an_abs_norm);
	Ak = Ak_tmp(1:ceil(N/2));
	
	% pre-specified frequency index for m1 and m2
	Ak_abs = abs(Ak);
	
	m1 = max(Ak_abs(k1)) + max(Ak_abs(k2));
	m2 = max(Ak_abs(k2))/max(Ak_abs(k1));
	
	[dummy,k3_idx] = max(Xk_abs);
	k3 = min(k3_idx);
	Xk_abs_k4 = Xk_abs;
	Xk_abs_k4([max(1,k3-3):min(k3+3,ceil(N/2))]) = -1;
	
	[temp, k4_idx] = max(Xk_abs_k4);
	k4 = min(k4_idx);
	
	m3 = Xk_abs(k4)/Xk_abs(k3);
	m4 = floor((k3+k4-1)/2);
	
	idx1_m5 = max(1,(m4+1-B2/2)):min((m4+1+B2/2),ceil(N/2));
	idx2_m5 = max(1,(m4+1-B1/2)):min((m4+1+B1/2),ceil(N/2));
	m5 = sum(Xk_abs(idx1_m5))/sum(Xk_abs(idx2_m5));
	
	%instantaneous amplitude features 
	acn_abs_norm = an_abs_norm - 1;
	Akc_tmp = fft(acn_abs_norm);
	Akc = Akc_tmp(1:ceil(N/2));
	Akc_abs = abs(Akc);
	
	gammaMax = max((Akc_abs(2:end)).^2)/N;
	
	%max value of DFT of analytical form
	an2_abs = an_abs.^2;
	an4_abs = an_abs.^4;
	Ak2_tmp = fft(an2_abs);
	Ak2 = Ak2_tmp(1:ceil(N/2));
	Ak2_abs = abs(Ak2);
	Ak4_tmp = fft(an4_abs);
	Ak4 = Ak4_tmp(1:ceil(N/2));
	Ak4_abs = abs(Ak4);
	gamma2 = max((Ak2_abs(2:end)).^2)/N;
	gamma4 = max((Ak4_abs(2:end)).^2)/N;
	
	% cumulants
	% complex envelope of the sampled signal expressed as ...
	R_an = real(an);
	I_an = imag(an);
	CRR = (1/N)*sum(R_an.^2);
	CRI = (1/N)*sum(R_an.*I_an);
	CII = (1/N)*sum(I_an.^2);
	CRRR = (1/N)*sum(R_an.^3);
	CRRI = (1/N)*sum((R_an.^2).*I_an);
	CRII = (1/N)*sum(R_an.*(I_an.^2));
	CIII = (1/N)*sum(I_an.^3);
	CRRRR = (1/N)*sum(R_an.^4) - 3*(CRR^2);
	CRRRI = (1/N)*sum((R_an.^3).*I_an) - CRR*CRI - CRR*CRI - CRI*CRR;
	CRRII = (1/N)*sum((R_an.^2).*(I_an.^2)) - CRR*CII - CRI*CRI - CRI*CRI;
	CRIII = (1/N)*sum(R_an.*(I_an.^3)) - CRI*CII - CRI*CII - CRI*CII;
	CIIII = (1/N)*sum(I_an.^4) - 3*CII;
	
	out = [m1 m2 m3 m4 m5 enull snrdB_hat gammaMax gamma2 gamma4 ...
CRR CRI CII ...
CRRR CRRI CRII CIII CRRRR CRRRI CRRII CRIII CIIII Xk_abs(45:160)'];
	
end	
		
		
