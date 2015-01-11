% pre-determined data to filter
function [dat_ook, dat_bpsk, dat_oqpsk, dat_bfskA, ...
dat_bfskB, dat_bfskR2] = whisker_fn(dat_ook, dat_bpsk, ...
dat_oqpsk, dat_bfskA, dat_bfskB, dat_bfskR2)

	% filter ook data for m4
	dat_ook = whisker_wrapper_fn(dat_ook, 3);
	% filter bfskA data for m3
	dat_bfskA = whisker_wrapper_fn(dat_bfskA, 2);
	% filter bfskA data for m5
	dat_bfskA = whisker_wrapper_fn(dat_bfskA, 4);
		
end
	
	
	


