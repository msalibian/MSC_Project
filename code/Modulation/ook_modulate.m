% Simulation of signal corresponding to the OOK modulation format.
%
% Parameters
% ----------
% n : length of input symbols
% fs : sampling frequency
% sps : samples per symbol
% fif : intermediate frequency
% sd : sigma paramter for AWGN
% norm_factor : normalization factor
% 
% Returns
% -------
% xn_noise_if : received signal
% sigpow : normalized signal power
% nn : AWGN
%
function [xn_noise_if, sigpow, nn] = ook_modulate(n, fs, sps, fif, sd, norm_factor)
	% random binary sequence
	data = randi([0 1], n, 1);
	
	xn = rectpulse(data, sps);
	
	% build time sequence
	t = 0:1/fs:(length(xn)/fs-1/fs);
	% transpose time sequence to obtain column vector
	t = t';
    
	u = rand(1);
	
    % complex signal
	xn_if_cmpx = xn.*exp(i*2*pi*(fif*t+u)).*sqrt(norm_factor);

	xn_if = real(xn_if_cmpx);
	
    sigpow = mean(xn_if.^2);
    
	% generate AWGN
	nn = sd*randn(length(xn_if),1);
	% add noise to signal to obtain received signal
	xn_noise_if = xn_if + nn;
    
end
	
	
	