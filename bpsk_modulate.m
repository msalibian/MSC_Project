function [xn_noise_if, sigpow] = bpsk_modulate(n, fs, sps, fif, dsss, sd)
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

%{
  rCosSpec=fdesign.pulseshaping(sps,'Raised Cosine','Nsym,Beta',filtSpanInSymbols,rolloff);
  hTxFilter = design(rCosSpec);
  upsampled = upsample(modData, sps) ;
  FltDelay = sps*(filtSpanInSymbols-1)/2;
  xn = filter (hTxFilter , [ upsampled ; zeros(FltDelay,1) ] );
%}

	%modulate bpsk signal with raised cosine filter	
	xn = step(hTxFilter, modData);

	%build time sequence
	t = 0:1/fs:(length(xn)/fs-1/fs);
	%transpose time sequence to obtain column vector
	t = t';
	
	%mix to low intermediate frequency, fif
	%xn = real(xn.*exp(i*2*pi*fif*t));
	%and initial phase
	xn = real(xn.*exp(i*2*pi*(fif*t+rand(1))));

	%generate noise sequence
	nn = sd*randn(length(xn),1);
	
	%add noise to received signal
	xn_noise_if = xn + nn;
	%calculate signal power for this sample
	sigpow = mean((xn).^2);

end
	
	
	