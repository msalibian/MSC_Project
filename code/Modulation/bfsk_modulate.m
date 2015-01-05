
function [xn_noise_if, sigpow, nn, xn_noise_if_cmpx] = bfskA_modulate(n, fs, Rs, fd, sps, fif, enc, sd)
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

%{
	if strcmp(enc, '3of6')
		data = [randi([0 1], ceil(n/2), 1), ... 
randi([0 1], ceil(n/2), 1)];
		data_3of6 = arrayfun(@threeofsix, data(:,1), data(:,2), ...
'UniformOutput', false);
		data_3of6 = cell2mat(data_3of6);
		data = data_3of6(:);
	end
%}
	
	%create modulator system object
	hMod = comm.FSKModulator(2, fd, Rs, ...
	'SamplesPerSymbol', sps);
	%modulate bfskA signal with random sequence
	xn = step(hMod, data);
		
	%build time sequence
	t = 0:1/fs:(length(xn)/fs-1/fs);
	%transpose time sequence to obtain column vector
	t = t';

	xn_if_cmpx = xn.*exp(i*2*pi*(fif*t+rand(1)));
	
	%mix to low intermediate frequency, fif
	%xn = real(xn.*exp(i*2*pi*fif*t));
	%and initial phase
	xn_if = real(xn_if_cmpx);
	
	%generate noise sequence
	nn = sd*randn(length(xn),1);
	
	%add noise to received signal
	xn_noise_if = xn_if + nn;
	%calculate signal power for this sample
	sigpow = mean(xn_if.^2);
	
	nn_cmpx = sd*sqrt(-1)*randn(length(xn_if), 1);
	
	xn_noise_if_cmpx = xn_if_cmpx + nn + nn_cmpx;
	
	if ~all(real(xn_noise_if_cmpx) == xn_noise_if)
		error('ook complex and real received signals differ')
	end
	
end

