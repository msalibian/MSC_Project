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
% gc : complex channel gain 
%
% Returns
% -------
% xn_noise_if : received signal
% sigpow : normalized signal power
% nn : AWGN
%
function [xn_noise_if, sigpow, nn] = ook_modulate(n, fs, sps, fif, sd, norm_factor, gc)
	% random binary sequence
	data = randi([0 1], n, 1);
	
	xn = rectpulse(data, sps);
	
	% build time sequence
	t = 0:1/fs:(length(xn)/fs-1/fs);
	% transpose time sequence to obtain column vector
	t = t';
    
	u = rand(1);
	
    % the following lines of code construct the received signal r[k].
    % r[k] = gc*s[k] + n[k]
    % gc is the channel gain using a frequency-flat slowing fading channel.
    % s[k] is the transmitted signal corresponding to xn_if_cmpx below.
    % n[k] is the AWGN corresponding to nn below.
    % r[k] corresponds to xn_noise_if below.
    
    % complex signal
	xn_if_cmpx = xn.*exp(i*2*pi*(fif*t+u)).*sqrt(norm_factor);
    
	xn_if = real(gc.*xn_if_cmpx);
	
    sigpow = mean(xn_if.^2);
    
    % adjust noise standard deviation parameter to ensure SNR =
    % (|gc|^2)*signal_power/noise_power
    sd = abs(gc)*sd;
	% generate AWGN
	nn = sd*randn(length(xn_if),1);
	% add noise to signal to obtain received signal
	xn_noise_if = xn_if + nn;
    
end
	
	
	