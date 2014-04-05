%directory to output data
cd('/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/OQPSK')
%add path containing bpsk_modulate function
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')

clear

%{
Comments:
1. The spreading needs verification.
2. I used minimum shift keying in place of oqpsk with half-sine pulse.
Minimum shift keying is 2-ary. Perhaps I should let symbol rate be 400 
instead of 200 in the paper?
3. m4 is correct which is roughly the average of k3 and k4, where
k3 is the frequency at abs max of power spectrum of dig. intermediate
frequency. k4 is max with at least 4 freq indices away from k3.
This tells us the frequencies where maximum occurs are correct, but 
the ratios of the two maximums where they occur are off.  
%}

%parameters
fs = 6.25e6; %sampling frequency
Rs = 2e5; %symbol rate
dsss = 4; %spreading factor
sps = round(fs/Rs); %samples per symbol
fif = 1e6; %low intermediate frequency
N = 512; %length of observation window
P = 2000; %number of features for each snr
k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
B1 = 36; B2 = 18; %feature_extract for m3 and m4
%run this if we know the signal power
sigpow = .5;
%run this if we do NOT know the signal power
%{sigpow = 0;
L = 1000;
for l = 1:L
	[temp, sigpow_tmp] = oqpsk_modulate(ceil(1e5/sps), fs, sps, fif, dsss, 1);
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
	[xn_tmp, temp] = oqpsk_modulate(ceil(2*N/sps/dsss), fs, sps, fif, dsss, sd);
	%take last N elements to avoid transients
	xn = xn_tmp(N:2*N-1);
	%call function to extract features
	[m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2);
	%record the snr and features to data matrix
	X(p,:) = [snrdB m1 m2 m3 m4 m5];
end
%output file name of data
outf = strcat('X_oqpsk_', num2str(snrdB), '.csv');
%write out data
csvwrite(outf, X);


