%% load validation data
load("validation.mat")
X_valid = table2array(validation(:, 4:18)); % Features
tic
%% Compute feature importance for the top models
YfitValidEnsemble = zeros(length(X_valid), numTrees, numBootstraps);
YfitValidEnsembleUncertainties = zeros(length(X_valid), numTrees, numBootstraps);
for i = 1:numTrees
    for j = 1:numBootstraps
        fprintf('Predicting validation using tree size %d/%d, bootstrap %d/%d...\n', i, numTrees, j, numBootstraps);
        [YfitValidEnsemble(:, i, j),YfitValidEnsembleUncertainties(:, i, j)] =...
            predict(Mdl{i, j}, X_valid);
    end
end
tic
YfitValidEnsembleTopModels = YfitValidEnsemble(:, topModelIndices);
YfitValidEnsembleAvg = mean(YfitValidEnsembleTopModels, 2);
PredictionXValidTimesAvg = toc; % Store the prediction averaging time

tic
YfitValidEnsembleUncertaintiesTopModels = YfitValidEnsembleUncertainties(:, topModelIndices);
YfitValidEnsembleUncertaintiesAvg = mean(YfitValidEnsembleUncertaintiesTopModels, 2);
PredictionXValidUncertaintyTimesAvg = toc; % Store the prediction uncertainties time
toc
%% save results
% Concatenate the two vectors horizontally
DataToWrite = [YfitValidEnsembleAvg, YfitValidEnsembleUncertaintiesAvg];
% Write the data to an Excel file
writematrix(DataToWrite, 'ValidPred.xlsx', 'Sheet', 1, 'Range', 'A2');
% Define the column headers
headers = {'yValidPred', 'uncertainty'};
% Write the headers to the Excel file
writecell(headers, 'ValidPred.xlsx', 'Sheet', 1, 'Range', 'A1');
