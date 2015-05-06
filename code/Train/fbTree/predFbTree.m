% Prediction function of FBT using the thresholds computed through 
% the worst-case analyses.
% The function iterates through each testing tuple and makes a 
% prediction by comparing the feature values with the thresholds.
% 
% Parameters
% ----------
% newdata : testing data
% thresholds : thresholds computed using fbTree function
%
% Returns
% -------
% cl_vec : array of class predictions
%
function cl_vec = predict_kuba_fn(newdata, thresholds)
	threshold1 = thresholds(1);
	threshold2 = thresholds(2);
	threshold3 = thresholds(3);
	threshold4 = thresholds(4);
	threshold5 = thresholds(5);
	if length(thresholds) > 5
		threshold6 = thresholds(6);		
	end

	cl_vec = zeros(size(newdata,1),1);
	
	for i = 1:size(newdata, 1)
		exp1 = newdata(i,2) > threshold1; %expression1
		exp2 = newdata(i,3) > threshold2;
		exp3 = newdata(i,4) > threshold3;
		exp4 = newdata(i,5) > threshold4;
		exp5 = newdata(i,6) > threshold5;
		
		if(exp1)
			if(exp2)
				cl = 2;
			else
				cl = 1;
			end
		else
			if(exp3)
				if(exp4)
					cl = 5;
				else
					if(exp5)
						cl = 4;
					else
						cl = 3;
					end
				end
			else
				cl = 6;
			end
		end
		cl_vec(i) = cl;	
	end

end
				


