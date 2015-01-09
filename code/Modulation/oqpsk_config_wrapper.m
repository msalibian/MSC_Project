
function oqpsk_config_wrapper(out_dir, N, P, snrdB_vec, nX)

	fs = 6.25e6; %sampling frequency
	Rs = 4e5; %symbol rate
	dsss = 4; %spreading factor
	sps = round(fs/Rs); %samples per symbol
	fif = 1e6; %low intermediate frequency

	k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
	B1 = 36; B2 = 18; %feature_extract for m3 and m4
	sigpow = .5;

	sd_vec = sqrt(sigpow./(10.^(snrdB_vec/10)));
	X_all = zeros(P*length(snrdB_vec), nX);
	k = 1; %index to update feature matrix

	for s = 1:length(snrdB_vec)
		sd = sd_vec(s);
		snrdB = snrdB_vec(s);
		for p = 1:P
			[xn_tmp, temp, nn_tmp] = oqpsk_modulate(ceil(2*N/sps/dsss), fs, sps, fif, dsss, sd);
			xn = xn_tmp(N:2*N-1);
			nn = nn_tmp(N:2*N-1);
			feat_vals = feature_extract(xn, k1, k2, B1, B2, nn);
			X_all(k,:) = [snrdB feat_vals 3];
			k = k + 1;
		end	
		fprintf('Run SNR: %d Complete\n', s);
	end
	
	outf = strcat(out_dir, '/oqpsk_P', num2str(P), '.csv');
	
	csvwrite(outf, X_all);

end
