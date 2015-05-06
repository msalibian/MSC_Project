% Feature extraction of received signal xn.
%
% Parameters
% ----------
% xn : received signal
% k1, k2 : frequency indexes
% B1, B2 : parameters used for obtaining m3 and m4 features
%
% Returns
% -------
% out : array of feature variables for one observation
%
function out = feature_extract(xn, k1, k2, B1, B2)
	N = length(xn);
    
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
	
	% max value of DFT of analytical form
    % gc change: divide by ma before squaring
    an2_abs_norm = (an_abs/ma).^2;
	an4_abs_norm = (an_abs/ma).^4;
	Ak2_tmp = fft(an2_abs_norm);
	Ak2 = Ak2_tmp(1:ceil(N/2));
	Ak2_abs = abs(Ak2);
	Ak4_tmp = fft(an4_abs_norm);
	Ak4 = Ak4_tmp(1:ceil(N/2));
	Ak4_abs = abs(Ak4);
	gamma2 = max((Ak2_abs(2:end)).^2)/N;
	gamma4 = max((Ak4_abs(2:end)).^2)/N;
	
	% cumulants
	% complex envelope of the sampled signal expressed as an
	% gc change: divide an by ma
    R_an = real(an/ma);
	I_an = imag(an/ma);
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
	
    % gc change for |R[k]|'s: divide by mr
    xn_abs = abs(xn);
    mr = mean(xn_abs);
    Rk_tmp = fft(xn/mr);
    Rk = Rk_tmp(1:ceil(N/2));
    Rk_abs = abs(Rk);
    
	out = [m1 m2 m3 m4 m5 gammaMax gamma2 gamma4 ...
CRR CRI CII ...
CRRR CRRI CRII CIII CRRRR CRRRI CRRII CRIII CIIII Rk_abs(45:160)'];
	
end
