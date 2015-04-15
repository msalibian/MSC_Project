% Simulation of OOK modulation format including pre-processing of 
%		received signal and feature extraction. The data that is simulated 
%		is described as follows (see nX description under Parameters):
%		Column 1 : SNR
%		Column 2-(nX-1) : Feature variables
%		Column nX : Modulation format (OOK encoded as 1).
%	The simulated data is saved to the output directory specified by 
%		out_dir as described below.
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
		
	% normalized signal power
  % normalization is necessary to retain unbiased features
  %  in particular statistical cumulants
  sigpow = .5; 
	norm_factor = 2; %normalizing factor

  % Array of parameters of sigmas corresponding to SNRs
	sd_vec = sqrt(sigpow./(10.^(snrdB_vec/10)));
	% A matrix with all zeros to store data later.
  X_all = zeros(P*length(snrdB_vec), nX);
	% An index to indicate the next row of X_all.
  k = 1; 

  % for each snr simulate P samples
	for s = 1:length(snrdB_vec)
		sd = sd_vec(s);
		snrdB = snrdB_vec(s);
		for p = 1:P
			% essentially we doubled the obs window size as input 
      %  however, in the next line of code, we keep only the 
      %  second half of the signal
      [xn_tmp, temp, nn_tmp] = ook_modulate(ceil(2*N/sps), fs, sps, fif, sd, norm_factor);
      % real part of received signal
      xn = xn_tmp(N:2*N-1);
			% noise
      nn = nn_tmp(N:2*N-1);
			% complex part of received signal
			feat_vals = feature_extract(xn, k1, k2, B1, B2, nn);
			X_all(k,:) = [snrdB feat_vals 1];
			k = k + 1;
		end	
		fprintf('Run SNR: %d Complete\n', s);
	end
	
	outf = strcat(out_dir, '/ook_P', num2str(P), '.csv');
	
	csvwrite(outf, X_all);

end



