%% Identify the top models based on MSE
%% Adjust the numTopModels
numTopModels = 1/100;
numModels = numTrees * numBootstraps;
numTopModels = round(numModels * numTopModels);
disp(num2str(numTopModels))
% this to change the percentage of top models to consider
mseValuesVector = reshape(mseValues, [1, numModels]);
[sortedRmseValues, sortedIndices] = sort(mseValuesVector);
topModelIndices = sortedIndices(1:numTopModels);

%% Average the predictions from the top models to get the final ensemble prediction
tic
YfitTestEnsembleTopModels = YfitTestEnsemble(:, topModelIndices);
YfitTestEnsembleAvg = mean(YfitTestEnsembleTopModels, 2);
PredictionXTestTimesAvg = toc; % Store the prediction averaging time

r2YfitTestEnsembleAvg = calculate_r2(YfitTestEnsembleAvg,y_test);
mseTest = (mean((y_test - YfitTestEnsembleAvg).^2));

tic
YfitTestEnsembleUncertaintiesTopModels = YfitTestEnsembleUncertainties(:, topModelIndices);
YfitTestEnsembleUncertaintiesAvg = mean(YfitTestEnsembleUncertaintiesTopModels, 2);
PredictionXTestUncertaintyTimesAvg = toc; % Store the prediction uncertainties time

tic
YfitTrainEnsembleTopModels = YfitTrainEnsemble(:, topModelIndices);
YfitTrainEnsembleAvg = mean(YfitTrainEnsembleTopModels, 2);
PredictionXTrainTimesAvg = toc; % Store the prediction averaging time

r2YfitTrainEnsembleAvg = calculate_r2(YfitTrainEnsembleAvg,y_train);
mseTrain = (mean((y_train - YfitTrainEnsembleAvg).^2));

tic
YfitTrainEnsembleUncertaintiesTopModels = YfitTrainEnsembleUncertainties(:, topModelIndices);
YfitTrainEnsembleUncertaintiesAvg = mean(YfitTrainEnsembleUncertaintiesTopModels, 2);
PredictionXTrainUncertaintyTimesAvg = toc; % Store the prediction uncertainties time
