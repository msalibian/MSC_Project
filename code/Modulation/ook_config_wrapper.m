% Simulation of OOK modulation format including pre-processing of received 
% signal and feature extraction. The data that is simulated is described 
% as follows (see nX description under Parameters):
%   Column 1 : SNR
%   Column 2-(nX-1) : Feature variables
%   Column nX : Modulation format (OOK encoded as 1).
% The simulated data is saved to the output directory specified by out_dir 
% as described below.
%
% Parameters
% ----------
% out_dir : output directory on local computer.
% N : observation window size.
% P : number of observations per modulation and SNR.
% snrdB_vec : array of SNRs (integers) eg. -25, -24,....,13
% nX : number of columns in total.
%
function ook_config_wrapper(out_dir, N, P, snrdB_vec, nX)
	
	fs = 6.25e6; %sampling frequency
	Rs = 125e3; %symbol rate
	sps = round(fs/Rs); %samples per symbol
	fif = 1e6; %low intermediate frequency

	k1 = 2:8; k2 = 26:28; %frequency indexes
	B1 = 36; B2 = 18; %params for feature_extract for m3 and m4
	
    % Normalize the signals to have an estimated signal power of 0.5.
    % All six modulations are to use a signal power of 0.5.
    % 
    % In each of the <modulation>_config_wrapper.m scripts we computed the 
    % unnormalized signal powers to be 0.25, .0203, 0.5, 0.5, 0.5, and 0.5
    % for OOK, BPSK, OQPSK, BFSK-A, BFSK-B, and BFSK-R2 respectively.
    % 
    % Not using the same signal power would cause the results to be 
    % erroneous since OOK and BPSK modulation formats are easily
    % distinguishable based on the difference in signal powers. 
    %
    % See ook_modulate.m to see how sigpow is computed.
    % In ook_modulate.m, the signal power (sigpow) is estimated by 
    % sigpow = (1/N)*sum(x[1]^2, x[2]^2,.., x[N]^2).
    % 
    % The estimated signal power for OOK without normalization is 0.25 as
    % shown below.
    % Uncomment and run the following lines to confirm the unnormalized 
    % signal power.
    %
    % We are setting channel gain to be 1 here to show the signal power.
    %
    %sigpow = 0;
    %L = 100000;
    %for l = 1:L
    %  [temp, sigpow_tmp] = ook_modulate(ceil(2*N/sps), fs, sps, fif, 1, 1, 1);
    %	sigpow = sigpow + sigpow_tmp;
    %	l
    %end
    %sigpow = sigpow/L;
    
    % Therefore, as shown in ook_modulate.m, a normalization factor of 2 
    % (norm_factor = 2) is applied to the signal so that (displayed as pseudo-code here):
    % sigpow = (1/N)*norm_factor*sum(x[1]^2, x[2]^2,..., x[N]^2)
    % sigpow = (1/N)*sum((sqrt(norm_factor)*x[1])^2,...,
    %                   (sqrt(norm_factor)*x[N])^2))
    %        = 0.5
    
    % Specify the normalizaing factor as described above used in the
    % ook_modulate function.
	norm_factor = 2;
    % Specify the signal power to be 0.5.
    sigpow = .5;
    
    % Array of sigmas to obtain the corresponding SNRs.
	% Derive noise variance parameter from (SNR in dB) = 10log((g^2 * signal
	%_power)/(noise_power)) where g^2 = 1.    
    sd_vec = sqrt(sigpow./(10.^(snrdB_vec/10)));
	% A matrix initialized with all zeros to store the simulation data.
    X_all = zeros(P*length(snrdB_vec), nX);
	% An index to indicate the next row of X_all to store.
    k = 1;
    
    % Iterate through each value of SNR.
	for s = 1:length(snrdB_vec)
		sd = sd_vec(s);
		snrdB = snrdB_vec(s);
        % complex channel gain
        gc = abs(randn(1))*exp(i*2*pi*rand(1));
        for p = 1:P
            % Simulate a signal by calling ook_modulate function using the 
            % parameters specified above. The first parameter corresponds 
            % to the length of input symbols. Notice how the observation 
            % window size is doubled. In the subsequent lines of code 
            % after ook_modulate, we keep only the second half of the 
            % signal corresponding to the enlarged observation window size.
            [xn_tmp, temp, nn_tmp] = ook_modulate(ceil(2*N/sps), fs, sps, fif, sd, norm_factor, gc);
            % Real part of received signal
            xn = xn_tmp(N:2*N-1);
			% Call the feature extraction function.
            feat_vals = feature_extract(xn, k1, k2, B1, B2);
			% The value 1 shown in the following array indicates the 
            % observation belongs to OOK. 
            X_all(k,:) = [snrdB feat_vals 1];
			k = k + 1;
        end	
	end
	
	outf = strcat(out_dir, '/ook_P', num2str(P), '.csv');
	
	csvwrite(outf, X_all);
    
    fprintf('OOK complete\n');
    
end



