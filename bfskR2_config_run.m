cd('/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/BFSKR2')
%add path containing bpsk_modulate function
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')

clear

%{
1. The carrier frequency of bfskR2 in Table 1 of Kuba's paper, 'Development 
and Implementation of a Feature-Based Automatic Classification Algorithm
for Communication Standards in the 868 MHz Band' gives 
868.03 + i*.06 where i is a number from 0 to 9. I usually would fix, 
fif which is the intermediate frequency. Search for 'fifi' below, 
where I let fifi <- fif + randi([0 9], 1, 1)*6e4 for each parameter 
calculation.

2. frequency separation indicates a tolerance of 
4.8..7.2 kHz in the paper. I fixed it to 6.
%}

%parameters
fs = 6.25e6; %sampling frequency
Rs = 4800; %symbol rate
fd = 6000; %frequency separation
sps = round(fs/Rs); %samples per symbol
%low intermediate frequency
%allow a random incremental frequency of +i*.06
%where 0<= i <=9
%fif here is where i == 0
fif = 7.3e5;
N = 512; %length of observation window
P = 2000; %number of features for each snr
k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
B1 = 36; B2 = 18; %feature_extract for m3 and m4
%indicate manchester encoding for bfsk modulation
enc = 'Manchester';
%run this if we know the signal power
sigpow = .5;
%run this if we do NOT know the signal power
%{
sigpow = 0;
L = 1000;
for l = 1:L
	fifi = fif + randi([0 9], 1, 1)*6e4;
	[temp, sigpow_tmp] = bfsk_modulate(ceil(1e6/sps/2), fs, Rs, fd, sps, fifi, enc, 1);
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
	%as indicated in the paper, the intermediate frequency ranges from
	%the following increment
	fifi = fif + randi([0 9], 1, 1)*6e4;
	%function to modulate signal
	[xn_tmp, temp] = bfsk_modulate(ceil(2*N/sps/2), fs, Rs, fd, sps, fifi, enc, sd);
	%take last N elements to avoid transients
	xn = xn_tmp(N:2*N-1);
	%call function to extract features
	[m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2);
	%record snr and features to data matrix
	X(p,:) = [snrdB m1 m2 m3 m4 m5];
end	
%output file name of data
outf = strcat('X_bfskR2_', num2str(snrdB), '.csv');
%write out data
csvwrite(outf, X);







