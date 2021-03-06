% Simulation of BFSK-A modulation format including pre-processing of 
% received signal and feature extraction. See ook_config_wrapper.m to 
% see a description of the simulation data.
%
% Parameters
% ----------
% out_dir : output directory on local computer.
% N : observation window size.
% P : number of observations per modulation and SNR.
% snrdB_vec : array of SNRs (integers) eg. -25, -24,....,13
% nX : number of columns in total.
%
function bfskA_config_wrapper(out_dir, N, P, snrdB_vec, nX)

	fs = 6.25e6; %sampling frequency
	Rs = 32768; %symbol rate
	fd = 50000; %frequency separation
	sps = round(fs/Rs); %samples per symbol
	fif = 1e6; %low intermediate frequency

	k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
	B1 = 36; B2 = 18; %feature_extract for m3 and m4
	enc = 'Manchester';
	
    % The estimated signal power for BFSK-A without normalization is 0.5 
    % as shown below.
    % Uncomment and run the following lines to confirm the unnormalized 
    % signal power.
    %
    % We are setting channel gain to be 1 here to show the signal power.
    %
    %sigpow = 0;
    %L = 500;
    %for l = 1:L
    %	[temp, sigpow_tmp] = bfsk_modulate(ceil(1e5/sps), fs, Rs, fd, sps, fif, enc, 1);
    %	sigpow = sigpow + sigpow_tmp;
    %	l
    %end
    %sigpow = sigpow/L;
    %
    
    sigpow = .5;
	% Derive noise variance parameter from (SNR in dB) = 10log((g^2 * signal
	%_power)/(noise_power)) where g^2 = 1.
    sd_vec = sqrt(sigpow./(10.^(snrdB_vec/10)));
	X_all = zeros(P*length(snrdB_vec), nX);
	k = 1; %index to update feature matrix
	
    % Iterate through each value of SNR.
	for s = 1:length(snrdB_vec)
		sd = sd_vec(s);
		snrdB = snrdB_vec(s);
		% complex channel gain
        gc = abs(randn(1))*exp(i*2*pi*rand(1));
        for p = 1:P
			% Simulate a signal by calling bfsk_modulate function using the 
            % parameters specified above.
            [xn_tmp, temp, nn_tmp] = bfsk_modulate(ceil(2*N/sps/2), fs, Rs, fd, sps, fif, enc, sd, gc);
			% Real part of received signal
            xn = xn_tmp(N:2*N-1);
            % Call the feature extraction function.
			feat_vals = feature_extract(xn, k1, k2, B1, B2);
			% The value 4 shown in the following array indicates the 
            % observation belongs to BFSK-A.
            X_all(k,:) = [snrdB feat_vals 4];
			k = k + 1;
		end	
    end
	
	outf = strcat(out_dir, '/bfskA_P', num2str(P), '.csv');
	
	csvwrite(outf, X_all);
    fprintf('BFSK-A complete\n');
end	
	
	
