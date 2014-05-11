%function for modulation of ook
function [xn_noise_if, sigpow] = ook_modulate(n, fs, sps, fif, sd)
	%random binary sequence
	data = randi([0 1], n, 1);
	
	xn = rectpulse(data, sps);
	
	%build time sequence
	t = 0:1/fs:(length(xn)/fs-1/fs);
	%transpose time sequence to obtain column vector
	t = t';
	
	%mix to low intermediate frequency, fif
	%xn = real(xn.*exp(i*2*pi*fif*t));
	%and initial phase
	u = rand(1);
	xn_if = real(xn.*exp(i*2*pi*(fif*t+u)));
	
	%generate noise sequence
	nn = sd*randn(length(xn_if),1);
	%add noise to received signal
	xn_noise_if = xn_if + nn;
	%calculate signal power for this sample
	sigpow = mean((xn_if).^2);

	%calculate ber if ber_flag == true
	%{
	if ber_flag == true
		hDemod = comm.PAMDemodulator(2, 'BitOutput' ,true);
		hError = comm.ErrorRate('ComputationDelay', 1);
		
		xn_if_cmpx = xn.*exp(i*2*pi*(fif*t+u));
		xn_noise_if_cmpx = xn_if_cmpx + nn;
		
		xn_received = step(hDemod, xn_noise_if_cmpx);
		%xn_received = real(xn_noise_if_cmpx.*exp(-i*2*pi*(fif*t+u)));
		ber = step(hError, xn, xn_received);
	end		
	%}
end
	
	
	