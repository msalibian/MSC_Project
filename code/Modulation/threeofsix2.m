%takes in 4 bits and conditions and outputs 
%6 bits corresponding to encoding.
function b = threeofsix2(x1, x2, x3, x4)
	%if the 4 bits match then give corresponding
	%6 bit output
	if sum([x1 x2 x3 x4] == [0 0 0 0]) == 2
		b = [0 1 0 1 1 0]';
	elseif sum([x1 x2 x3 x4] == [0 0 0 1]) == 2
		b = [0 0 1 1 0 1]';
	elseif sum([x1 x2 x3 x4] == [0 0 1 0]) == 2
		b = [0 0 1 1 1 0]';
	elseif sum([x1 x2 x3 x4] == [0 0 1 1]) == 2
		b = [0 0 1 0 1 1]';
	elseif sum([x1 x2 x3 x4] == [0 1 0 0]) == 2
		b = [0 1 1 1 0 0]';
	elseif sum([x1 x2 x3 x4] == [0 1 0 1]) == 2
		b = [0 1 1 0 0 1]';
	elseif sum([x1 x2 x3 x4] == [0 1 1 0]) == 2
		b = [0 1 1 0 1 0]';
	elseif sum([x1 x2 x3 x4] == [0 1 1 1]) == 2
		b = [0 1 0 0 1 1]';
	elseif sum([x1 x2 x3 x4] == [1 0 0 0]) == 2
		b = [1 0 1 1 0 0]';
	elseif sum([x1 x2 x3 x4] == [1 0 0 1]) == 2
		b = [1 0 0 1 0 1]';
	elseif sum([x1 x2 x3 x4] == [1 0 1 1]) == 2
		b = [1 0 0 1 1 0]';
	elseif sum([x1 x2 x3 x4] == [1 1 0 0]) == 2
		b = [1 0 0 0 1 1]';
	elseif sum([x1 x2 x3 x4] == [1 1 0 1]) == 2
		b = [1 1 0 1 0 0]';
	elseif sum([x1 x2 x3 x4] == [1 1 0 1]) == 2
		b = [1 1 0 0 0 1]';
	elseif sum([x1 x2 x3 x4] == [1 1 1 0]) == 2
		b = [1 1 0 0 1 0]';
	elseif sum([x1 x2 x3 x4] == [1 1 1 1]) == 2
		b = [1 0 1 0 0 1]';
	
end	
