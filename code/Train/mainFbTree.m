
clear

addpath('code/Train')

P = 50; %training data
P2 = 200; %testing data

ookTrn = csvread(strcat('data/Modulation/ook_P', num2str(P), '.csv'));
bpskTrn = csvread(strcat('data/Modulation/bpsk_P', num2str(P), '.csv'));
oqpskTrn = csvread(strcat('data/Modulation/oqpsk_P', num2str(P), '.csv'));
bfskATrn = csvread(strcat('data/Modulation/bfskA_P', num2str(P), '.csv'));
bfskBTrn = csvread(strcat('data/Modulation/bfskB_P', num2str(P), '.csv'));
bfskR2Trn = csvread(strcat('data/Modulation/bfskR2_P', num2str(P), '.csv'));

datTrnList = {ookTrn, bpskTrn, oqpskTrn, bfskATrn, bfskBTrn, bfskR2Trn};

thresholds = fbTree(datTrnList);

ookTest = csvread(strcat('data/Modulation/ook_P', num2str(P2), '.csv'));
bpskTest = csvread(strcat('data/Modulation/bpsk_P', num2str(P2), '.csv'));
oqpskTest = csvread(strcat('data/Modulation/oqpsk_P', num2str(P2), '.csv'));
bfskATest = csvread(strcat('data/Modulation/bfskA_P', num2str(P2), '.csv'));
bfskBTest = csvread(strcat('data/Modulation/bfskB_P', num2str(P2), '.csv'));
bfskR2Test = csvread(strcat('data/Modulation/bfskR2_P', num2str(P2), '.csv'));

datTest = [ookTest; bpskTest; oqpskTest; bfskATest; bfskBTest; bfskR2Test];

pr = predFbTree(datTest, thresholds);

% remember the last col of datTest contains the true class
resDf = [datTest(:,[1 size(datTest,2)]) pr];

outf = 'data/Fitted/fbTree/fbTree.txt';
csvwrite(outf, resDf);


