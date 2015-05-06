% Simulation of BFSK-R2 modulation format including pre-processing of 
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
function bfskR2_config_wrapper(out_dir, N, P, snrdB_vec, nX)

	fs = 6.25e6; %sampling frequency
	Rs = 4800; %symbol rate
	fd = 6000; %frequency separation
	sps = round(fs/Rs); %samples per symbol
	%low intermediate frequency
	%allow a random incremental frequency of +i*.06
	%where 0<= i <=9
	%fif here is where i == 0
	fif = 7.3e5;

	k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
	B1 = 36; B2 = 18; %feature_extract for m3 and m4
	enc = 'Manchester';
	
    % The estimated signal power for BFSK-R2 without normalization is 0.5 
    % as shown below.
    % Uncomment and run the following lines to confirm the unnormalized 
    % signal power.
    %
    % We are setting channel gain to be 1 here to show the signal power.
    %
    %sigpow = 0;
    %L = 1000;
    %for l = 1:L
    %	[temp, sigpow_tmp] = bfsk_modulate(ceil(1e5/sps), fs, Rs, fd, sps, fif, enc, 1);
    %	sigpow = sigpow + sigpow_tmp;
    %	l
    %end
    %sigpow = sigpow/L;
    
    sigpow = .5;
    
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
			% random intermediate frequency of .73 MHz + i*.06 for randomly
			% selected integer i.
            fifi = fif + randi([0 9], 1, 1)*6e4;
			% Simulate a signal by calling bfsk_modulate function using the 
            % parameters specified above.
            [xn_tmp, temp, nn_tmp] = bfsk_modulate(ceil(2*N/sps/2), fs, Rs, fd, sps, fifi, enc, sd, gc);
			xn = xn_tmp(N:2*N-1);
            % Call the feature extraction function.
			feat_vals = feature_extract(xn, k1, k2, B1, B2);
			% The value 6 shown in the following array indicates the 
            % observation belongs to BFSK-R2.
            X_all(k,:) = [snrdB feat_vals 6];
			k = k + 1;
		end	
	end	
	
	outf = strcat(out_dir, '/bfskR2_P', num2str(P), '.csv');
	
	csvwrite(outf, X_all);
    fprintf('BFSK-R2 complete\n');
end	

