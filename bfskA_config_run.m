%directory to output data
cd('/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/BFSKA')
%add path containing bpsk_modulate function
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')

clear

%{
Comments:
1. The manchester encoding is straightforward, so will only need
a quick verification
2. In Kuba's paper, 'Automatic Communication Standard Recognition 
Wireless Smart Home Networks', the frequency separation on the 
bfsk modulation has a tolerance from 40..80. I'm unsure if this 
value can be adjusted. By default, I gave it 60.
%}

%parameters
fs = 6.25e6; %sampling frequency
Rs = 32768; %symbol rate
fd = 60000; %frequency separation
sps = round(fs/Rs); %samples per symbol
fif = 1e6; %low intermediate frequency
N = 512; %length of observation window
P = 2000; %number of features for each snr
k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
B1 = 36; B2 = 18; %feature_extract for m3 and m4
%indicate manchester encoding for bfsk modulation function
enc = 'Manchester';
%run this if we know the signal power
sigpow = .5;
%run this if we do NOT know the signal power
%{
sigpow = 0;
L = 1000;
for l = 1:L
	[temp, sigpow_tmp] = bfsk_modulate(ceil(1e6/sps/2), fs, Rs, fd, sps, fif, enc, 1);
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
	[xn_tmp, temp] = bfsk_modulate(ceil(2*N/sps/2), fs, Rs, fd, sps, fif, enc, sd);
	%take last N elements to avoid transients
	xn = xn_tmp(N:2*N-1);
	%call function to extract features
	[m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2);
	%record snr and features to data matrix
	X(p,:) = [snrdB m1 m2 m3 m4 m5];
end	
%output file name of data
outf = strcat('X_bfskA_', num2str(snrdB), '.csv');
%write out data
csvwrite(outf, X);


