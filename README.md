## Modulation Recognition in the 868 MHz Band using Classification Trees and Random Forests

**M.Sc. Project**

**Ken Lau**

**Supervisors: Matías Salibián-Barrera and Lutz Lampe**

**UBC**

This README file guides us through the workflow of our study. The workflow consists of 3 major components. First, modulation data is generated through MATLAB. Then, feature-based tree is implemented in MATLAB. While, classification tree and random forest are implemented in R. Finally, predicitive performance is verified for each model.

This guide is complementary to the paper (to be posted later). 

<img src="visualizations/flow-bigPicture.png" width="450" height="200">

#### Simulating Modulation Data
The code that performs the simulation is in ["code/Modulation"](https://github.com/kenlau177/MSC_Project/tree/master/code/Modulation).

In particular, ["code/Modulation/main_simulation_all.m"](https://github.com/kenlau177/MSC_Project/blob/master/code/Modulation/main_simulation_all.m) script is automated to simulate the modulation data. Note that MATLAB's Communication Toolbox is required.

Data is output to ["data/Modulation"](https://github.com/kenlau177/MSC_Project/tree/master/data/Modulation). 

There are 6 modulation types: ook, bpsk, oqpsk, bfksA, bfskB, bfskR2. Refer to the paper for more details. In the paper, P=50 corresponds to the training data and P=200 corresponds to the testing data.

<img src="visualizations/flow-simulating-mods.png" width="450" height="300">

#### Fit Feature-Based Tree
Run ["code/Train/mainFbTree.m"](https://github.com/kenlau177/MSC_Project/blob/master/code/Train/mainFbTree.m) to fit the feature-based tree.

Depends on fbTree.m, aggregate.m, calculateThreshold.m, and predFbTree.m. Can be found in: ["code/Train"](https://github.com/kenlau177/MSC_Project/blob/master/code/Train)

Input: 
- Training and testing modulation data directly from the output of the previous step.

Output: 
- A text file with the predicted versus true modulation type as a function of SNR.
  * The first column corresponds to the SNR
  * The second column is the true modulation type
  * The third column is the predicted modulation type
  * Stored in ["data/Fitted/fbTree"]("https://github.com/kenlau177/MSC_Project/blob/master/data/Fitted/fbTree")

<img src="visualizations/flow-fit-fbTree.png" width="450" height="300">






