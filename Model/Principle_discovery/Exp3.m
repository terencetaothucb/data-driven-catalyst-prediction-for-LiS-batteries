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
if iscell(data.Px)
    data.Px = cellfun(@str2double, data.Px);
end
if iscell(data.Rx)
    data.Rx = cellfun(@str2double, data.Rx);
end
if iscell(data.Ead)
    data.Ead = cellfun(@str2double, data.Ead);
end

% Determine unique values in the CN and Rm columns
unique_CN = unique(data.CN);
unique_Rm = unique(data.Rm);

% Initialize a structure to store the results
statistics_results_Px = struct();
statistics_results_Rx = struct();

% Loop over each unique CN value
for i = 1:length(unique_CN)
    cn = unique_CN(i);  
    
    % Loop over each unique Rm value
    for j = 1:length(unique_Rm)
        rm = unique_Rm(j); 
        
        % Filter the data for the current combination of CN and Rm
        combination_data = data(data.CN == cn & data.Rm == rm, :);     
        
        % Study the influence of Px to Ead
        if height(combination_data) > 1
            % Group by Px and calculate mean and std for Ead in each group
            grp_stats_Px = grpstats(combination_data, 'Px', {'mean', 'std'}, 'DataVars', 'Ead');        
            % Store the results
            key = sprintf('CN%d_Rm%d', cn, rm);
            statistics_results_Px.(key) = grp_stats_Px;
            cor_Px_Ead(i*j) = corr(combination_data.Px,combination_data.Ead);
        end
        
        % Study the influence of Rx to Ead
        if height(combination_data) > 1
            % Group by Rx and calculate mean and std for Ead in each group
            grp_stats_Rx = grpstats(combination_data, 'Rx', {'mean', 'std'}, 'DataVars', 'Ead');        
            % Store the results
            statistics_results_Rx.(key) = grp_stats_Rx;
            cor_Rx_Ead(i*j) = corr(combination_data.Rx,combination_data.Ead);
        end
    end
end

% Initialize an empty table for the Px results
final_results_Px = table();
% Iterate over the statistics_results to populate the final_results table
for fieldName = fieldnames(statistics_results_Px)'
    key = fieldName{1};
    stats = statistics_results_Px.(key);
    % Create a temporary table for the current combination
    tempTable = table();
    tempTable.CombinationName = repmat(string(key), height(stats), 1);
    tempTable.Px = stats.Px;
    tempTable.GroupCount = stats.GroupCount;
    tempTable.mean_Ead = stats.mean_Ead;
    tempTable.std_Ead = stats.std_Ead;  
    % Append the temporary table to the final results table
    final_results_Px = [final_results_Px; tempTable];
end
% Write the final results table for Px to an Excel file
outputFilename_Px = 'statistics_results_Px_Exp3.xlsx';
writetable(final_results_Px, outputFilename_Px);
disp(['Px Results are written to ', outputFilename_Px]);

% Initialize an empty table for the Rx results
final_results_Rx = table();
% Iterate over the statistics_results to populate the final_results table
for fieldName = fieldnames(statistics_results_Rx)'
    key = fieldName{1};
    stats = statistics_results_Rx.(key);
    % Create a temporary table for the current combination
    tempTable = table();
    tempTable.CombinationName = repmat(string(key), height(stats), 1);
    tempTable.Rx = stats.Rx;
    tempTable.GroupCount = stats.GroupCount;
    tempTable.mean_Ead = stats.mean_Ead;
    tempTable.std_Ead = stats.std_Ead;  
    % Append the temporary table to the final results table
    final_results_Rx = [final_results_Rx; tempTable];
end
% Write the final results table for Rx to an Excel file
outputFilename_Rx = 'statistics_results_Rx_Exp3.xlsx';
writetable(final_results_Rx, outputFilename_Rx);
disp(['Rx Results are written to ', outputFilename_Rx]);
