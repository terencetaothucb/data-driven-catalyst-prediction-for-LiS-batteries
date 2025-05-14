clear
% Load the data from an Excel file
filename = 'Principle_discovery.xlsx'; % Update the path if the file is in a different directory
% Read the second row for the headers
opts = detectImportOptions(filename, 'Sheet', 'Sheet1', 'Range', 'A2');
opts.DataRange = 'A2';
featureNames = readtable(filename, opts);
% Convert the table row to a cell array of strings
featureNames = table2cell(featureNames);
featureNames = string(featureNames); % Ensure all feature names are strings
% Read the rest of the data starting from the third row
opts.DataRange = 'A3';
data = readtable(filename, opts);
% Ensure that the data is numeric. If not, handle or convert it appropriately.
if iscell(data.CN)
    data.CN = cellfun(@str2double, data.CN);
end
if iscell(data.Rm)
    data.Rm = cellfun(@str2double, data.Rm);
end
if iscell(data.Rx)
    data.Rx = cellfun(@str2double, data.Rx);
end
if iscell(data.Ead)
    data.Ead = cellfun(@str2double, data.Ead);
end
% Determine unique values in the Rm and Rx columns
unique_Rm = unique(data.Rm);
unique_Rx = unique(data.Rx);
% Initialize a structure to store the results
statistics_results = struct();
% Loop over each unique Rm value
for i = 1:length(unique_Rm)
    rm = unique_Rm(i);  
    % Loop over each unique Rx value
    for j = 1:length(unique_Rx)
        rx = unique_Rx(j); 
        % Filter the data for the current combination of Rm and Rx
        combination_data = data(data.Rm == rm & data.Rx == rx, :);  
        % Check if the combination has more than one CN value
        if length(unique(combination_data.CN)) > 1
            % Group by CN and calculate mean and std for Ead in each group
            grp_stats = grpstats(combination_data, 'CN', {'mean', 'std'}, 'DataVars', 'Ead');        
            % Store the results
            key = sprintf('Rm%d_Rx%d', rm, rx);
            statistics_results.(key) = grp_stats;

            cor_CN_Ead(i*j) = corr(combination_data.CN,combination_data.Ead);
        end
    end
end

% Initialize an empty table for the results
final_results = table();
% Iterate over the statistics_results to populate the final_results table
for fieldName = fieldnames(statistics_results)'
    key = fieldName{1};
    stats = statistics_results.(key);
    % Create a temporary table for the current combination
    tempTable = table();
    tempTable.CombinationName = repmat(string(key), height(stats), 1);
    tempTable.CN = stats.CN;
    tempTable.GroupCount = stats.GroupCount;
    tempTable.mean_Ead = stats.mean_Ead;
    tempTable.std_Ead = stats.std_Ead;  
    % Append the temporary table to the final results table
    final_results = [final_results; tempTable];
end
% Write the final results table to an Excel file
outputFilename = 'statistics_results_Exp1.xlsx'; % You can change the file name and path as needed
writetable(final_results, outputFilename);
disp(['Results are written to ', outputFilename]);

