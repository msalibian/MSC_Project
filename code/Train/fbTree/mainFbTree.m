% Main script for training the feature-based tree (FBT). Predictions 
% on the testing data are also made and saved at the location 
% sepcified by the variable 'outf'.

clear

% Path to reference the functions to fit the FBT.
addpath('code/Train/fbTree')

% Recall P is the number of observations per modulation and SNR.
% size P for training data
% size P2 for testing data
P = 50; 
P2 = 200;

% Read in training data for each of the six modulations.
ookTrn = csvread(strcat('data/Modulation/ook_P', num2str(P), '.csv'));
bpskTrn = csvread(strcat('data/Modulation/bpsk_P', num2str(P), '.csv'));
oqpskTrn = csvread(strcat('data/Modulation/oqpsk_P', num2str(P), '.csv'));
bfskATrn = csvread(strcat('data/Modulation/bfskA_P', num2str(P), '.csv'));
bfskBTrn = csvread(strcat('data/Modulation/bfskB_P', num2str(P), '.csv'));
bfskR2Trn = csvread(strcat('data/Modulation/bfskR2_P', num2str(P), '.csv'));

% Remove outliers from modulation training data sets indicated 
% by boxplots (see whisker_fn).
%
% The worst-case plots of Figure 3 of [5] suggests that some outliers 
% may have been removed from the data. For example, fig 3 indicates that 
% max(m2) of OOK is less than min(m2) of BPSK, however, fig 2 indicates 
% the opposite inequality direction assuming the outliers are included. 
% It is difficult to predict all the outliers removed in the experiments 
% performed in [5], but we made a good attempt with respect to figs 2 and 3 
% of [5].
%
% The following line of code calls whisker_fn that takes outliers into
% account.
[ookTrn, bpskTrn, oqpskTrn, bfskATrn, bfskBTrn, bfskR2Trn] = whisker_fn(...
	ookTrn, bpskTrn, oqpskTrn, bfskATrn, bfskBTrn, bfskR2Trn); 

datTrnList = {ookTrn, bpskTrn, oqpskTrn, bfskATrn, bfskBTrn, bfskR2Trn};

% Computes the thresholds used to construct the FBT using 
% worst-case analysis. See the fbTree.m for more information.
thresholds = fbTree(datTrnList);

% Read in testing data sets.
ookTest = csvread(strcat('data/Modulation/ook_P', num2str(P2), '.csv'));
bpskTest = csvread(strcat('data/Modulation/bpsk_P', num2str(P2), '.csv'));
oqpskTest = csvread(strcat('data/Modulation/oqpsk_P', num2str(P2), '.csv'));
bfskATest = csvread(strcat('data/Modulation/bfskA_P', num2str(P2), '.csv'));
bfskBTest = csvread(strcat('data/Modulation/bfskB_P', num2str(P2), '.csv'));
bfskR2Test = csvread(strcat('data/Modulation/bfskR2_P', num2str(P2), '.csv'));

% Concatenate testing data into one matrix.
datTest = [ookTest; bpskTest; oqpskTest; bfskATest; bfskBTest; bfskR2Test];

% Makes predictions for each tuple of datTest (see predFbTree.m).
pr = predFbTree(datTest, thresholds);

% Construct a data matrix of the class predictions to be used 
% in visualizing the predictive performance of the FBT as shown 
% in Figs 2 and 3 of the manuscript. 
% The data matrix consists of:
%   Column 1 : SNR
%   Column 2 : true modulation label
%   Column 3 : predicted modulation
resDf = [datTest(:,[1 size(datTest,2)]) pr];

outf = 'data/Fitted/fbTree/fbTree.txt';
csvwrite(outf, resDf);


