% Simulation of signal corresponding to the BFSK-A, BFSK-B, and BFSK-R2 
% modulation formats.
%
% Parameters
% ----------
% n : length of input symbols
% fs : sampling frequency
% Rs : symbol rate
% fd : frequency separation
% sps : samples per symbol
% fif : intermediate frequency
% enc : type of encoding: Manchester or 3 of 6 encoding
% sd : sigma paramter for AWGN
% gc : complex channel gain 
%
% Returns
% -------
% xn_noise_if : received signal
% sigpow : normalized signal power
% nn : AWGN
%
function [xn_noise_if, sigpow, nn] = bfskA_modulate(n, fs, Rs, fd, sps, fif, enc, sd, gc)
	%enc is an encoding option which should be specified
	%as either 'Manchester' or '3of6' strings
	
	%strcmp compares the strings and is true when the strings 
	%are equal
	%applies Manchester encoding
	if strcmp(enc, 'Manchester')
		data = randi([0 1], n, 1);
		%manchester as per IEEE 802.3
		data_man = arrayfun(@(x) xor([1 0]',x), data, ...
'UniformOutput', false);
		data_man = cell2mat(data_man);
		data = data_man;
	end
	
	%applies 3 of 6 encoding
	%I followed the method from the following paper
	%url: www.silabs.com/Support%20Documents/TechnicalDocs/Si102x-3x.pdf‎
	%find section 15.3, page 211 of document
	if strcmp(enc, '3of6')
		%create matrix of 4 columns with random bits of {0, 1}
		%rounded up to include sufficient number of samples
		data = [randi([0 1], ceil(n/4), 1), ...
randi([0 1], ceil(n/4), 1), randi([0 1], ceil(n/4), 1), ...
randi([0 1], ceil(n/4), 1)];
		%3 of 6 encoding, input: 4 bits, ouput: 6 bits
		data_3of6 = arrayfun(@threeofsix2, data(:,1), data(:,2), ...
data(:,3), data(:,4), 'UniformOutput', false);
		data_3of6 = cell2mat(data_3of6);
		data = data_3of6;
	end
	
	%create modulator system object
	hMod = comm.FSKModulator(2, fd, Rs, ...
	'SamplesPerSymbol', sps);
	%modulate bfskA signal with random sequence
	xn = step(hMod, data);
		
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
	nn = sd*randn(length(xn),1);
	
	%add noise to received signal
	xn_noise_if = xn_if + nn;
	%calculate signal power for this sample
	
end

