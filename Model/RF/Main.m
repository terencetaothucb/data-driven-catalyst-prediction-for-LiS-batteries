clear
tic
%% load feature and labels
SplitData
%% Train random forest
RF
%% Select the best models based on the error
SelectModels
%%
disp(['R2(Training)',num2str(r2YfitTrainEnsembleAvg)])
disp(['R2(Testing)',num2str(r2YfitTestEnsembleAvg)])
%% save prediction results  
toc

%clearvars -except materialTrainBootstrapped labelTrainBootstrapped trainingTimes