clear

%path containing the scripts to run simulations
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Automation')
%path containing the script to create plots
addpath('/ubc/ece/home/ll/grads/kenl/MSC_Project/Code/Visualizations')

%make sure to configure <mod>_config_run.m files to 
%write output data destination
bpsk_config_run
oqpsk_config_run
bfskA_config_run
bfskB_config_run
bfskR2_config_run
ook_config_run

%data should be simulated as .csv files to desired output directories

%Now, run kuba_plots.m to create boxplots
%make sure to change all the input and output directory names
%in 'kuba_plots.m'
kuba_plots


