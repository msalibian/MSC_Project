%directory to output data
cd('/ubc/ece/home/ll/grads/kenl/MSC_Project/Data/Noise')
%add path containing bpsk_modulate function and feature extract
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')

clear

N = 512; %length of observation window
P = 2000; %number of features for each snr
k1 = 2:8; k2 = 26:28;
B1 = 36; B2 = 18; %params for feature_extract for m3 and m4
sigpow_mods = [.25 .025 .5 .5 .5 .5];
snrdB = 15;
sd_mods = sqrt(sigpow_mods./10^(snrdB/10));
sd = mean(sd_mods);

X = zeros(P, 6);
for p = 1:P
	xn_tmp = noise_modulate(2*N, sd);
	xn = xn_tmp(N:2*N-1);
	[m1 m2 m3 m4 m5] = feature_extract(xn, k1, k2, B1, B2);
	X(p,:) = [snrdB m1 m2 m3 m4 m5];
end

outf = strcat('X_noise_', num2str(snrdB), '.csv');

csvwrite(outf, X);



