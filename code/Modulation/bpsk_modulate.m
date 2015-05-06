% Simulation of signal corresponding to the BPSK modulation format.
%
% Parameters
% ----------
% n : length of input symbols
% fs : sampling frequency
% sps : samples per symbol
% fif : intermediate frequency
% dsss : spreading factor
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
function [xn_noise_if, sigpow, nn] = bpsk_modulate(n, fs, sps, fif, dsss, sd, norm_factor, gc)
	%symbol to chip mapping in IEEE 802.15.4
	pn(:,1) = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0]';
	pn(:,2) = [0 0 0 0 1 0 1 0 0 1 1 0 1 1 1]';

	%generate symbols
	data = randi([0 1], n, 1);
	%spreading by mapping symbols to chip
	data_dsss = arrayfun(@(x) pn(:,x+1), data, ...
'UniformOutput', false);

	%new input sequence for bpsk modulation
	data_dsss = cell2mat(data_dsss);
	
	%create modulator system object
	hMod = comm.BPSKModulator;
	%modulate bpsk signal with random sequence
	modData = step(hMod, data_dsss);
	
	%filter span in symbols, default is 10
	%filtSpanInSymbols = 10;
	filtSpanInSymbols = 25;
	%alpha as indicated in the paper
	rolloff = 1;
	%create raised cosine receive filter system object
	hTxFilter = comm.RaisedCosineTransmitFilter(...
	'RolloffFactor', rolloff, ...
	'FilterSpanInSymbols', filtSpanInSymbols, ...
	'OutputSamplesPerSymbol', sps, ...
	'Shape', 'Normal'); 

	%modulate bpsk signal with raised cosine filter	
	xn = step(hTxFilter, modData);

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
        
	xn_if_cmpx = xn.*exp(i*2*pi*(fif*t+rand(1))).*sqrt(norm_factor);
	
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
	
	
	