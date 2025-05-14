clear
load("validation.mat")
load("y_valid_pred.mat")
% Assuming validation is already loaded into the workspace
% Screen the table for rows where validation.Ad equals 'Li2S2'
screenedValidation = validation(strcmp(validation.Ad, 'Li2S2'), :);
% Load the Excel file
[~, ~, raw] = xlsread('candidates_from_expert.xlsx');
% Extract header names
headerNames = raw(1, :);
% Convert raw data (excluding headers) to a table
candidatesExpert = cell2table(raw(2:end, :), 'VariableNames', headerNames);
candidates = innerjoin(screenedValidation, candidatesExpert, 'Keys', {'Mat', 'CF'});

% Define the center and error ranges
peak_center = 2.747;
distance = [1.5];
delta = 0.1;

% Initialize cell arrays to hold the keysMatched for each error range
keysMatchedRanges = cell(length(distance), 1);
remainingDataRanges = cell(length(distance), 1);

% Calculate new centers based on the peak_center and distances
new_centers = [peak_center - distance, peak_center + distance];
% Loop through each new center
for i = 1:length(new_centers)
    center = new_centers(i);
    
    % Find indexes where y_valid_pred is within delta of the new center
    idxRange = find(y_valid_pred >= (center - delta) & y_valid_pred <= (center + delta));
    
    % Use these indexes to define keysMatched and Others_Left/Right for the current new center
    keysMatchedRanges{i} = screenedValidation(idxRange, {'Mat', 'CF'});
end

% Step 1: Extract the key columns (assuming 'Mat' and 'CF' are the keys)
keysScreened = screenedValidation(:, {'Mat', 'CF'});

% Initialize a structure to hold the statistics for each feature and error range
statsStruct = struct();

% Loop through each error range and process differences
for rangeIndex = 1:length(new_centers)
    % Extract keysMatched for the current range
    keysMatched = keysMatchedRanges{rangeIndex};
    
    % Find the difference in keys for the current range
    [~, idx] = setdiff(keysScreened, keysMatched, 'rows');
    
    % Index into screenedValidation to get the full rows for the current range
    remainingDataRanges{rangeIndex} = screenedValidation(idx, :);
    
    % Process remainingDataRange as needed for each range...
    remainingData = remainingDataRanges{rangeIndex};
    
    % Visualization and Statistical Analysis for each range's remaining data
    allFieldNames = fieldnames(remainingData);
    FeatureNames = allFieldNames(4:18); % adjust indices as per your data structure
    
    numFeatures = length(FeatureNames);
    numRows = 3; % Adjust as per the number of features
    numCols = 5; % Adjust as per the number of features
    fig = figure;
    statsArray = {};
    for i = 1:numFeatures
        subplot(numRows, numCols, i);
        featureDataMatched = candidates.(FeatureNames{i});
        featureDataRemaining = remainingData.(FeatureNames{i});
        
        if isnumeric(featureDataMatched) && isnumeric(featureDataRemaining)
            [fMatched{rangeIndex,i}, xMatched{rangeIndex,i}] = ksdensity(featureDataMatched);
            [fRemaining{rangeIndex,i}, xRemaining{rangeIndex,i}] = ksdensity(featureDataRemaining);

            plot(xMatched{rangeIndex,i}, fMatched{rangeIndex,i}, 'LineWidth', 4);
            hold on;
            plot(xRemaining{rangeIndex,i}, fRemaining{rangeIndex,i}, 'LineWidth', 4);
            hold off;
            legend('Candidates', 'Non-Candidates');
            title(FeatureNames{i});
            
            % Append statistics to the statsArray
            meanMatched = mean(featureDataMatched);
            stdMatched = std(featureDataMatched);
            meanRemaining = mean(featureDataRemaining);
            stdRemaining = std(featureDataRemaining);
            statsArray(end+1, :) = {FeatureNames{i}, meanMatched, stdMatched, meanRemaining, stdRemaining};
        else
            title(sprintf('%s: Non-numeric data', FeatureNames{i}));
        end
    end
    set(fig, 'Position', get(0, 'Screensize'));
    sgtitle(sprintf('Feature Distributions for New Center %g: Candidates vs Non-Candidates', new_centers(rangeIndex)));
    
    % Convert statsArray to a table with proper headers
    statsTable = cell2table(statsArray, 'VariableNames', {'Features', 'Candidates_mean', 'Candidates_std', 'Non-Candidates_mean', 'Non-Candidates_std'});
    
    fieldName = sprintf('NewCenter_%g', new_centers(rangeIndex));
    fieldName = strrep(fieldName, '.', '_'); % Replace '.' with '_'
    statsStruct.(fieldName) = statsTable;

end

excelFileName = 'Candidates_Feature_Analysis.xlsx';
for rangeIndex = 1:length(new_centers)
    fieldName = sprintf('NewCenter_%g', new_centers(rangeIndex));
    fieldName = strrep(fieldName, '.', '_'); % Replace '.' with '_'
    sheetName = sprintf('New_Center_%s', fieldName);
    writetable(statsStruct.(fieldName), excelFileName, 'Sheet', sheetName, 'WriteVariableNames', true);
end


for rangeIndex = 1:length(new_centers)
    % Create filenames based on rangeIndex
    filename_matched = sprintf('Matched_Data_Range_%d.xlsx', rangeIndex);
    filename_remaining = sprintf('Remaining_Data_Range_%d.xlsx', rangeIndex);
    
    % Initialize cell arrays to store data
    matched_data = cell(length(FeatureNames), 201); % Adjusted size to accommodate 200 columns
    remaining_data = cell(length(FeatureNames), 201); % Adjusted size to accommodate 200 columns
    
    for i = 1:length(FeatureNames)
        % Get the feature name
        feature_name = FeatureNames{i};
    
        % Get the data for the current feature and rangeIndex
        data_matched = [xMatched{rangeIndex,i}, fMatched{rangeIndex,i}];
        data_remaining = [xRemaining{rangeIndex,i}, fRemaining{rangeIndex,i}];
    
        % Reshape data_matched and data_remaining to 1 by 200
        % data_matched = reshape(data_matched', 1, []);
        % data_remaining = reshape(data_remaining', 1, []);
    
        % Store data in cell arrays
        for j = 2:201
            matched_data{i, 1} = feature_name; % Assign feature name
            remaining_data{i, 1} = feature_name; % Assign feature name
            matched_data{i, j} = data_matched(j - 1); % Assign data from 2nd to 201st index
            remaining_data{i, j} = data_remaining(j - 1); % Assign data from 2nd to 201st index
        end
    end

    
    % Generate variable names
    variableNames = [{'Feature'}, strcat('x', arrayfun(@(x) num2str(x), 1:100, 'UniformOutput', false)), strcat('y', arrayfun(@(y) num2str(y), 1:100, 'UniformOutput', false))];
    % Convert cell arrays to tables with appropriate column names
    matched_table = cell2table(matched_data, 'VariableNames', variableNames);
    remaining_table = cell2table(remaining_data, 'VariableNames', variableNames);

    % Write matched data to Excel file
    writetable(matched_table, filename_matched);
    
    % Write remaining data to Excel file
    writetable(remaining_table, filename_remaining);
end



clearvars -except remainingDataRanges candidates FeatureNames new_centers delta keysMatchedRanges variableNames
