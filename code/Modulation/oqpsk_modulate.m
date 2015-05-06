% Simulation of signal corresponding to the OQPSK modulation format.
%
% Parameters
% ----------
% n : length of input symbols
% fs : sampling frequency
% sps : samples per symbol
% fif : intermediate frequency
% dsss : spreading factor
% sd : sigma paramter for AWGN
% gc : complex channel gain 
%
% Returns
% -------
% xn_noise_if : received signal
% sigpow : normalized signal power
% nn : AWGN
%
function [xn_noise_if, sigpow, nn] = oqpsk_modulate(n, fs, sps, fif, dsss, sd, gc)
	
	%symbol to chip mapping for oqpsk
	%symbol for oqpsk is made from 4 bits, so there are 2^4
	%combinations. Each symbol is spread to 16 chips.
	pn(:,1) = [0 0 1 1 1 1 1 0 0 0 1 0 0 1 0 1]';
	pn(:,2) = [0 1 0 0 1 1 1 1 1 0 0 0 1 0 0 1]';
	pn(:,3) = [0 1 0 1 0 0 1 1 1 1 1 0 0 0 1 0]';
	pn(:,4) = [1 0 0 1 0 1 0 0 1 1 1 1 1 0 0 0]';
	pn(:,5) = [0 0 1 0 0 1 0 1 0 0 1 1 1 1 1 0]';
	pn(:,6) = [1 0 0 0 1 0 0 1 0 1 0 0 1 1 1 1]';
	pn(:,7) = [1 1 1 0 0 0 1 0 0 1 0 1 0 0 1 1]';
	pn(:,8) = [1 1 1 1 1 0 0 0 1 0 0 1 0 1 0 0]';
	pn(:,9) = [0 1 1 0 1 0 1 1 0 1 1 1 0 0 0 0]';
	pn(:,10) = [0 0 0 1 1 0 1 0 1 1 0 1 1 1 0 0]';
	pn(:,11) = [0 0 0 0 0 1 1 0 1 0 1 1 0 1 1 1]';
	pn(:,12) = [1 1 0 0 0 0 0 1 1 0 1 0 1 1 0 1]';
	pn(:,13) = [0 1 1 1 0 0 0 0 0 1 1 0 1 0 1 1]';
	pn(:,14) = [1 1 0 1 1 1 0 0 0 0 0 1 1 0 1 0]';
	pn(:,15) = [1 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0]';
	pn(:,16) = [1 0 1 0 1 1 0 1 1 1 0 0 0 0 0 1]';

	%generate symbols for oqpsk
	data = randi([0 15], n, 1);
	%spreading by mapping symbols to chips
	data_dsss = arrayfun(@(x) pn(:,x+1), data, ...
'UniformOutput', false);
	
	%new input sequence for oqpsk modulation
	data_dsss = cell2mat(data_dsss);
	
	%create modulator system object
	hMod = comm.MSKModulator('SamplesPerSymbol', sps, ...
'BitInput', true);
	%modulate oqpsk signal
	xn = step(hMod, data_dsss);
	
	%build time sequence
	t = 0:1/fs:(length(xn)/fs-1/fs);
	%transpose time sequence to obtain column vector
	t = t';
	
    % the following lines of code construct the received signal r[k].
    % r[k] = gc*s[k] + n[k]
    % gc is the channel gain using a frequency-flat slowing fading channel.
    % s[k] is the transmitted signal corresponding to xn_if_cmpx below.
    % n[k] is the AWGN corresponding to nn below.
    % r[k] corresponds to xn_noise_if below.
    
	xn_if_cmpx = xn.*exp(i*2*pi*(fif*t+rand(1)));
	
	xn_if = real(gc.*xn_if_cmpx);
	
    sigpow = mean(xn_if.^2);

    % adjust noise standard deviation parameter to ensure SNR =
    % (|gc|^2)*signal_power/noise_power
    sd = abs(gc)*sd;
	%generate noise sequence
	nn = sd*randn(length(xn_if),1);
	
	%add noise to received signal
	xn_noise_if = xn_if + nn;	

end

