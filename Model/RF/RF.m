%% initialization
rng("default")
%% bootstraps
numBootstraps = 30; % change this to the number of bootstraps you want
bootIndices = bootstrp(numBootstraps, @(x)x, (1:size(X_train, 1))')';

% Initialize the bootstrapped training data variables
XTrainBootstrapped = cell(1, numBootstraps);
YTrainBootstrapped = cell(1, numBootstraps);
materialTrainBootstrapped = cell(1, numBootstraps);
labelTrainBootstrapped = cell(1, numBootstraps);

for i = 1:numBootstraps
    XTrainBootstrapped{i} = X_train(bootIndices(:, i), :);
    YTrainBootstrapped{i} = y_train(bootIndices(:, i), :);
    materialTrainBootstrapped{i} = material_train(bootIndices(:, i), :);
    labelTrainBootstrapped{i} = label_train(bootIndices(:, i), :);
end

%% training
numTrees = 10;
numPredictorsToSample = size(X_train, 2);
Mdl = cell(numTrees,numBootstraps);
bestRMSE = inf;
worstRMSE = -inf;
bestModelIdx = [0, 0];
worstModelIdx = [0, 0];

% Initialize the training time, rmse, R-squared, and prediction time variables
trainingTimes = zeros(numTrees, numBootstraps);
mseValues = zeros(numTrees, numBootstraps);
rSquaredValues = zeros(numTrees, numBootstraps);
importanceMatrix = zeros(numPredictorsToSample, numTrees, numBootstraps);
YfitTestEnsemble = zeros(length(y_test), numTrees, numBootstraps);
YfitTestEnsembleUncertainties = zeros(length(y_test), numTrees, numBootstraps);
PredictionXTestTimes = zeros(numTrees, numBootstraps);
YfitTrainEnsemble = zeros(length(y_train), numTrees, numBootstraps);
YfitTrainEnsembleUncertainties = zeros(length(y_train), numTrees, numBootstraps);
PredictionXTrainTimes = zeros(numTrees, numBootstraps);

for i = 1:numTrees
    for j = 1:numBootstraps
        fprintf('Training tree %d/%d, bootstrap %d/%d...\n', i, numTrees, j, numBootstraps);
        tic
        Mdl{i,j} = TreeBagger(i, XTrainBootstrapped{j}, YTrainBootstrapped{j},...
            'Method','regression','OOBPredictorImportance','on','NumPredictorsToSample',numPredictorsToSample);
        trainingTimes(i, j) = toc; % Store the training time
        % Predict on Testing set and compute RMSE
        [Yfit, YfitStd] = predict(Mdl{i,j},X_test);
        mse = (mean((y_test - Yfit).^2));

        % Store RMSE
        mseValues(i, j) = mse;
        
        % Compute R-squared
        ssres = sum((y_test - Yfit).^2);
        sstot = sum((y_test - mean(y_test)).^2);
        rSquared = 1 - ssres/sstot;
        rSquaredValues(i, j) = rSquared; % Store R-squared

        % If this model is better, update bestRMSE and bestModelIdx
        if mse < bestRMSE
            bestRMSE = mse;
            bestModelIdx = [i, j];
        end

        % If this model is worse, update worstRMSE and worstModelIdx
        if mse > worstRMSE
            worstRMSE = mse;
            worstModelIdx = [i, j];
        end

        % Get feature importance for each model
        importanceMatrix(:, i, j) = Mdl{i,j}.OOBPermutedPredictorDeltaError;

        % Store the predictions from each model
        tic
        [YfitTestEnsemble(:, i, j),YfitTestEnsembleUncertainties(:, i, j)] = predict(Mdl{i,j}, X_test);
        PredictionXTestTimes(i, j) = toc; % Store the prediction time
        tic
        [YfitTrainEnsemble(:, i, j),YfitTrainEnsembleUncertainties(:, i, j)] = predict(Mdl{i,j}, X_train);
        PredictionXTrainTimes(i, j) = toc; % Store the prediction time
    end
end

% Get the predictions and uncertainties for the best and worst models
[YfitTestBest, YfitTestBestUncertainties] = predict(Mdl{bestModelIdx(1), bestModelIdx(2)}, X_test);
[YfitTrainBest, YfitTrainBestUncertainties] = predict(Mdl{bestModelIdx(1), bestModelIdx(2)}, X_train);
[YfitTestWorst, YfitTestWorstUncertainties] = predict(Mdl{worstModelIdx(1), worstModelIdx(2)}, X_test);
[YfitTrainWorst, YfitTrainWorstUncertainties] = predict(Mdl{worstModelIdx(1), worstModelIdx(2)}, X_train);

% Compute MSE for the best and worst models
mseTestBest = (mean((y_test - YfitTestBest).^2));
mseTrainBest = (mean((y_train - YfitTrainBest).^2));
mseTestWorst = (mean((y_test - YfitTestWorst).^2));
mseTrainWorst = (mean((y_train - YfitTrainWorst).^2));
