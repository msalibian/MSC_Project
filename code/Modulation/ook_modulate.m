% function for modulation of ook
% n - length of bit sequence
function [xn_noise_if, sigpow, nn, xn_noise_if_cmpx] = ook_modulate(n, fs, sps, fif, sd, norm_factor)
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
	
	% generate sequence of noise
	nn = sd*randn(length(xn_if),1);
	% add noise to transmitted signal
	xn_noise_if = xn_if + nn;
	% calculate signal power for this sample
	sigpow = mean((imag(xn_if_cmpx)).^2);

	% noise component for imaginary part for features that use
	% imaginary part of signal
	nn_cmpx = sd*sqrt(-1)*randn(length(xn_if), 1);
	
	xn_noise_if_cmpx = xn_if_cmpx + nn + nn_cmpx;

	if ~all(real(xn_noise_if_cmpx) == xn_noise_if)
		error('ook complex and real received signals differ')
    end
    
end
	
	
	