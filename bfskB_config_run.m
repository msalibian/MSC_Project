%directory to output data
cd('/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/BFSKB')
%add path containing bpsk_modulate function
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')

clear

%{
1. 3 of 6 encoding needs verification.
2. similar to bfskA modulation, the frequency separation 
indicates a tolerance of 40..80 kHz in the paper.
%}

%parameters
fs = 6.25e6; %sampling frequency
Rs = 1e5; %symbol rate
fd = 60000; %frequency separation
sps = round(fs/Rs); %samples per symbol
fif = 1.65e6; %low intermediate frequency
N = 512; %length of observation window
P = 2000; %number of features for each snr
k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
B1 = 36; B2 = 18; %feature_extract for m3 and m4
%indicate 3 of 6 encoding in bfsk modulation function
enc = '3of6';
%run this if we know the signal power
sigpow = .5;
%run this if we do NOT know the signal power
%sigpow = 0;
%L = 1000;
%for l = 1:L
%	[temp, sigpow_tmp] = bfsk_modulate(ceil(1e6/sps/1.5), fs, Rs, fd, sps, fif, enc, 1);
%	sigpow = sigpow + sigpow_tmp;
%	l
%end
%sigpow = sigpow/L;

snrdB = 15;
%calculate variation of noise based on paper's snr transformation
sd = sqrt(sigpow/10^(snrdB/10));
%parametrer data to be recorded is
%snrdB followed by 5 features
X = zeros(P, 6);
for p = 1:P
	%function to modulate signal
	[xn_tmp, temp] = bfsk_modulate(ceil(2*N/sps/1.5), fs, Rs, fd, sps, fif, enc, sd);
	%take last N elements to avoid transients
	xn = xn_tmp(N:2*N-1);
	%call function to extract features
	[m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2);
	%record snr and features to data matrix
	X(p,:) = [snrdB m1 m2 m3 m4 m5];
end	
%output file name of data
outf = strcat('X_bfskB_', num2str(snrdB), '.csv');
%write out data
csvwrite(outf, X);



