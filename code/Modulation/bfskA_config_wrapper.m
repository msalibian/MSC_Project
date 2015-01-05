
function bfskA_config_wrapper(out_dir, N, P, snrdB_vec, nX)

	fs = 6.25e6; %sampling frequency
	Rs = 32768; %symbol rate
	fd = 50000; %frequency separation
	sps = round(fs/Rs); %samples per symbol
	fif = 1e6; %low intermediate frequency

	k1 = 2:8; k2 = 26:28; %feature_extract for m1 and m2
	B1 = 36; B2 = 18; %feature_extract for m3 and m4
	enc = 'Manchester';
	sigpow = .5;

	sd_vec = sqrt(sigpow./(10.^(snrdB_vec/10)));
	X_all = zeros(P*length(snrdB_vec), nX);
	k = 1; %index to update feature matrix
	
	for s = 1:length(snrdB_vec)
		sd = sd_vec(s);
		snrdB = snrdB_vec(s);
		for p = 1:P
			[xn_tmp, temp, nn_tmp, xn_cmpx_tmp] = bfsk_modulate(ceil(2*N/sps/2), fs, Rs, fd, sps, fif, enc, sd);
			xn = xn_tmp(N:2*N-1);
			nn = nn_tmp(N:2*N-1);
			xn_cmpx = xn_cmpx_tmp(N:2*N-1);
			feat_vals = feature_extract(xn, k1, k2, B1, B2, xn_cmpx, nn);
			X_all(k,:) = [snrdB feat_vals 4];
			k = k + 1;
		end	
		s
	end	
	
	outf = strcat(out_dir, '/bfskA_N', num2str(N), '_P', ...
num2str(P), '_snrdB', ... 
strcat(num2str(min(snrdB_vec)), ':', num2str(max(snrdB_vec))), ...
'_nX', num2str(nX), '.csv');
	
	csvwrite(outf, X_all);

end	
	
	
