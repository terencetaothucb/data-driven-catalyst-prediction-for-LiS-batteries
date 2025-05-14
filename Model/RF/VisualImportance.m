%% Compute feature importance for the top models
topModelsImportance = zeros(numTopModels, size(X_train, 2));
for i = 1:numTopModels
    modelIdx = topModelIndices(i);
    treeIdx = ceil(modelIdx / numBootstraps);
    bootstrapIdx = mod(modelIdx, numBootstraps);
    if bootstrapIdx == 0
        bootstrapIdx = numBootstraps;
    end
    topModelsImportance(i, :) = Mdl{treeIdx, bootstrapIdx}.OOBPermutedPredictorDeltaError;
end

%% Average and compute standard deviation of feature importance
meanImportance = mean(topModelsImportance, 1);
stdImportance = std(topModelsImportance, 0, 1);

% Remove NaN and Inf values
validIndices = ~isnan(meanImportance) & ~isinf(meanImportance);
validMeanImportance = meanImportance(validIndices);
validStdImportance = stdImportance(validIndices);

% Sort the valid feature importance values
[sortedMeanImportance, sortedIndices] = sort(abs(validMeanImportance), 'descend');

%% Plot top ten feature importance with error bars
figure(2);
% Get top ten features
NumTopFeatures = length(find(validIndices==1));
topTenMeanImportance = sortedMeanImportance(1:NumTopFeatures);
topTenStdImportance = validStdImportance(sortedIndices(1:NumTopFeatures));
topTenIndices = sortedIndices(1:NumTopFeatures);

% Plot top ten feature importance with error bars
bar(topTenMeanImportance);
hold on
errorbar(1:NumTopFeatures, topTenMeanImportance, topTenStdImportance, '.');
hold off
xlabel(['Top ',num2str(NumTopFeatures),' Features (sorted by importance)']);
ylabel('Importance');

% If you have feature names, you can display them on the x-axis
% Assume featureNames is a cell array of feature names
featureNames = dataset.Properties.VariableNames;
featureNames = featureNames(4:end);
featureNamesTopTen = featureNames(topTenIndices);
set(gca, 'XTickLabel', featureNamesTopTen);
