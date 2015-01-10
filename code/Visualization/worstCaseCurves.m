
clear

addpath('code/Train')

P = 50;

ookTrn = csvread(strcat('data/Modulation/ook_P', num2str(P), '.csv'));
bpskTrn = csvread(strcat('data/Modulation/bpsk_P', num2str(P), '.csv'));
oqpskTrn = csvread(strcat('data/Modulation/oqpsk_P', num2str(P), '.csv'));
bfskATrn = csvread(strcat('data/Modulation/bfskA_P', num2str(P), '.csv'));
bfskBTrn = csvread(strcat('data/Modulation/bfskB_P', num2str(P), '.csv'));
bfskR2Trn = csvread(strcat('data/Modulation/bfskR2_P', num2str(P), '.csv'));

datTrnList = {ookTrn, bpskTrn, oqpskTrn, bfskATrn, bfskBTrn, bfskR2Trn};

[threshold1, pp1_min, pp1_max] = calculateThreshold(datTrnList{2}, datTrnList{4}, 2, 5);

xx1 = -5:13;

y_min = ppval(pp1_min, xx1);
y_max = ppval(pp1_max, xx1);

out =[xx1', y_min', y_max'];

csvwrite('data/worstCaseDat.txt', out);




