%directory to output data
cd('/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/OOK')
%add path containing bpsk_modulate function and feature extract
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')

clear

%{
Comments:
The only incorrect parameter was m3. A fix was made in 
'feature_extract.m' where m3 calcated as ratio between 
|Xk4|/|Xk3| where k3 is frequency at abs max of power spectrum 
of digital intermediate frequency signal and k4 is max with 
at least 4 frequency indices difference from k3. 
Before: 
k4_idx = arrayfun(@(x) (x-3:x+3), k3_idx, ... 
After:
k4_idx = arrayfun(@(x) (x-4:x+4), k3_idx, ... 
ook should be entirely correct now.
%}

%parameters
fs = 6.25e6; %sampling frequency
Rs = 125e3; %symbol rate
sps = round(fs/Rs); %samples per symbol
fif = 1e6; %low intermediate frequency
N = 512; %length of observation window
P = 2000; %number of features for each snr
k1 = 2:8; k2 = 26:28;
B1 = 36; B2 = 18; %params for feature_extract for m3 and m4
%run this if we know the signal power
sigpow = .25;
%run this if we do NOT know the signal power
%sigpow = 0;
%L = 2000;
%for l = 1:L
%	[temp, sigpow_tmp] = ook_modulate(ceil(1e6/sps), fs, sps, fif, 1);
%	sigpow = sigpow + sigpow_tmp;
%	l
%end
%sigpow = sigpow/L;

snrdB = 15;
%calculate variation of noise based on paper's snr transformation
sd = sqrt(sigpow/10^(snrdB/10));
%parameter data to be recorded is
%snrdB followed by 5 features
X = zeros(P, 6);
for p = 1:P
	%function to modulate signal
	[xn_tmp, temp] = ook_modulate(ceil(2*N/sps), fs, sps, fif, sd);
	%take last N elements to avoid transients
	xn = xn_tmp(N:2*N-1);
	%call function to extract features
	[m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2);
	%record the snr and features to data matrix
	X(p,:) = [snrdB m1 m2 m3 m4 m5];
end
%output file name of data
outf = strcat('X_ook_', num2str(snrdB), '.csv');
%write out data
csvwrite(outf, X);


