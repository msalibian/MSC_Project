% Simulation of BPSK modulation format including pre-processing of 
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
function bpsk_config_wrapper(out_dir, N, P, snrdB_vec, nX)
    
	fs = 6.25e6; %sampling frequency
	Rs = 3e5; %symbol rate
	dsss = 15; %spreading factor
	sps = floor(fs/Rs); %samples per symbol
	fif = 1e6; %low intermediate frequency

	k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
	B1 = 36; B2 = 18; %feature_extract for m3 and m4

    % Normalize the signals to have an estimated signal power of 0.5.
    % All six modulations are to use a signal power of 0.5.
    % 
    % See ook_config_wrapper.m to see an explanation of why to keep  
    % the signal powers to be the same, and descriptions of computing
    % signal power (sigpow).
    % 
    % The estimated signal power for BPSK without normalization is 0.0203 
    % as shown below.
    % Uncomment and run the following lines to confirm the unnormalized 
    % signal power.
    %
	% sigpow = 0;
	% L = 1000;
	% for l = 1:L
	%	[temp, sigpow_tmp] = bpsk_modulate(ceil(2*N/sps/dsss), fs, sps, fif, dsss, 1, 1);
	%	sigpow = sigpow + sigpow_tmp;
	%	l
	% end
	% sigpow = sigpow/L;
    %
    % Therefore, as shown in bpsk_modulate.m, a normalization factor of 24.6305 
    % (norm_factor = 24.6305) is applied to the signal to ensure sigpow =
    % 0.5
   
	norm_factor = 24.6305;
	sigpow = .5;
    
    % Array of sigmas to obtain the corresponding SNRs.
	sd_vec = sqrt(sigpow./(10.^(snrdB_vec/10)));
	% A matrix initialized with all zeros to store the simulation data.
    X_all = zeros(P*length(snrdB_vec), nX);
	% An index to indicate the next row of X_all to store.
    k = 1;
	
    % Iterate through each value of SNR.
	for s = 1:length(snrdB_vec)
		sd = sd_vec(s);
		snrdB = snrdB_vec(s);
		for p = 1:P
			% Simulate a signal by calling bpsk_modulate function using the 
            % parameters specified above.
            [xn_tmp, temp, nn_tmp] = bpsk_modulate(ceil(2*N/sps/dsss), fs, sps, fif, dsss, sd, norm_factor);
			% Real part of received signal
            xn = xn_tmp(N:2*N-1);
			% Call the feature extraction function.
            feat_vals = feature_extract(xn, k1, k2, B1, B2);
			% The value 2 shown in the following array indicates the 
            % observation belongs to BPSK. 
            X_all(k,:) = [snrdB feat_vals 2];
			k = k + 1;
		end	
		fprintf('Run SNR: %d Complete\n', s);
	end
	
	outf = strcat(out_dir, '/bpsk_P', num2str(P), '.csv');
	
	csvwrite(outf, X_all);

end


