% Simulation of BFSK-B modulation format including pre-processing of 
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
function bfskB_config_wrapper(out_dir, N, P, snrdB_vec, nX)

	fs = 6.25e6; %sampling frequency
	Rs = 1e5; %symbol rate
	fd = 60000; %frequency separation
	sps = round(fs/Rs); %samples per symbol
	fif = 1.65e6; %low intermediate frequency

	k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
	B1 = 36; B2 = 18; %feature_extract for m3 and m4
	enc = '3of6';
	
    % The estimated signal power for BFSK-B without normalization is 0.5 
    % as shown below.
    % Uncomment and run the following lines to confirm the unnormalized 
    % signal power.
    %
    %sigpow = 0;
    %L = 1000;
    %for l = 1:L
    %	[temp, sigpow_tmp] = bfsk_modulate(ceil(1e5/sps), fs, Rs, fd, sps, fif, enc, 1);
    %	sigpow = sigpow + sigpow_tmp;
    %	l
    %end
    %sigpow = sigpow/L;
    %
    
    sigpow = .5;

	sd_vec = sqrt(sigpow./(10.^(snrdB_vec/10)));
	X_all = zeros(P*length(snrdB_vec), nX);
	k = 1; %index to update feature matrix

    % Iterate through each value of SNR.
	for s = 1:length(snrdB_vec)
		sd = sd_vec(s);
		snrdB = snrdB_vec(s);
		for p = 1:P
			% Simulate a signal by calling bfsk_modulate function using the 
            % parameters specified above.
            [xn_tmp, temp, nn_tmp] = bfsk_modulate(ceil(2*N/sps/2), fs, Rs, fd, sps, fif, enc, sd);
			% Real part of received signal
            xn = xn_tmp(N:2*N-1);
			% Call the feature extraction function.
			feat_vals = feature_extract(xn, k1, k2, B1, B2);
			% The value 5 shown in the following array indicates the 
            % observation belongs to BFSK-B.
            X_all(k,:) = [snrdB feat_vals 5];
			k = k + 1;
		end	
		fprintf('Run SNR: %d Complete\n', s);
	end	
	
	outf = strcat(out_dir, '/bfskB_P', num2str(P), '.csv');
	
	csvwrite(outf, X_all);

end	
	


