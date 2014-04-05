%directory to output data
cd('/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/BPSK')
%add path containing bpsk_modulate function
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')

clear

%{
Comments:
I changed the rolloff factor to 0.5 (1 in the paper) 
and set the filter 
span in symbols to 55 for the raised cosine filter. 
This seems to correct for the first two parameters. 
This was a naive modification. Now, whether I round up 
or down the samples per symbol can also affect the 
modulation, but doesn't make a big difference. 
%}

%parameters
fs = 6.25e6; %sampling frequency
Rs = 3e5; %symbol rate
dsss = 15; %spreading factor
sps = floor(fs/Rs); %samples per symbol
fif = 1e6; %low intermediate frequency
N = 512; %length of observation window
P = 2000; %number of features for each snr
k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
B1 = 36; B2 = 18; %feature_extract for m3 and m4
%run this if we know the signal power
sigpow = .025;
%run this if we do NOT know the signal power
%{
sigpow = 0;
L = 1000;
for l = 1:L
	[temp, sigpow_tmp] = bpsk_modulate(ceil(1e5/sps), fs, sps, fif, dsss, 1);
	sigpow = sigpow + sigpow_tmp;
	l
end
sigpow = sigpow/L;
%}

snrdB = 15;
%calculate variation of noise based on paper's snr transformation
sd = sqrt(sigpow/10^(snrdB/10));
%parameter data to be recorded is
%snrdB followed by 5 features
X = zeros(P, 6);
for p = 1:P
	%function to modulate signal
	[xn_tmp, temp] = bpsk_modulate(ceil(2*N/sps/dsss), fs, sps, fif, dsss, sd);
	%take last N elements to avoid transients
	xn = xn_tmp(N:2*N-1);
	%call function to extract features
	[m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2);
	%record the snr and features to data matrix
	X(p,:) = [snrdB m1 m2 m3 m4 m5];
end
%output file name of data
outf = strcat('X_bpsk_', num2str(snrdB), '.csv');
%write out data
csvwrite(outf, X);



