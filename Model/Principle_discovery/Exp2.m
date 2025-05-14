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
if iscell(data.Rx)
    data.Rx = cellfun(@str2double, data.Rx);
end
if iscell(data.Pm)
    data.Pm = cellfun(@str2double, data.Pm);
end
if iscell(data.Rm)
    data.Rm = cellfun(@str2double, data.Rm);
end
if iscell(data.Ead)
    data.Ead = cellfun(@str2double, data.Ead);
end

% Determine unique values in the CN and Rx columns
unique_CN = unique(data.CN);
unique_Rx = unique(data.Rx);

% Initialize a structure to store the results
statistics_results_Pm = struct();
statistics_results_Rm = struct();

% Loop over each unique CN value
for i = 1:length(unique_CN)
    cn = unique_CN(i);  
    
    % Loop over each unique Rx value
    for j = 1:length(unique_Rx)
        rx = unique_Rx(j); 
        
        % Filter the data for the current combination of CN and Rx
        combination_data = data(data.CN == cn & data.Rx == rx, :);     
        
        % Study the influence of Pm to Ead
        if height(combination_data) > 1
            % Group by Pm and calculate mean and std for Ead in each group
            grp_stats_Pm = grpstats(combination_data, 'Pm', {'mean', 'std'}, 'DataVars', 'Ead');        
            % Store the results
            key = sprintf('CN%d_Rx%d', cn, rx);
            statistics_results_Pm.(key) = grp_stats_Pm;
            cor_Pm_Ead(i*j) = corr(combination_data.Pm,combination_data.Ead);
        end
        
        % Study the influence of Rm to Ead
        if height(combination_data) > 1
            % Group by Rm and calculate mean and std for Ead in each group
            grp_stats_Rm = grpstats(combination_data, 'Rm', {'mean', 'std'}, 'DataVars', 'Ead');        
            % Store the results
            statistics_results_Rm.(key) = grp_stats_Rm;
            cor_Rm_Ead(i*j) = corr(combination_data.Rm,combination_data.Ead);
        end
    end
end

% Initialize an empty table for the Pm results
final_results_Pm = table();
% Iterate over the statistics_results to populate the final_results table
for fieldName = fieldnames(statistics_results_Pm)'
    key = fieldName{1};
    stats = statistics_results_Pm.(key);
    % Create a temporary table for the current combination
    tempTable = table();
    tempTable.CombinationName = repmat(string(key), height(stats), 1);
    tempTable.Pm = stats.Pm;
    tempTable.GroupCount = stats.GroupCount;
    tempTable.mean_Ead = stats.mean_Ead;
    tempTable.std_Ead = stats.std_Ead;  
    % Append the temporary table to the final results table
    final_results_Pm = [final_results_Pm; tempTable];
end
% Write the final results table for Pm to an Excel file
outputFilename_Pm = 'statistics_results_Pm_Exp2.xlsx';
writetable(final_results_Pm, outputFilename_Pm);
disp(['Pm Results are written to ', outputFilename_Pm]);

% Initialize an empty table for the Rm results
final_results_Rm = table();
% Iterate over the statistics_results to populate the final_results table
for fieldName = fieldnames(statistics_results_Rm)'
    key = fieldName{1};
    stats = statistics_results_Rm.(key);
    % Create a temporary table for the current combination
    tempTable = table();
    tempTable.CombinationName = repmat(string(key), height(stats), 1);
    tempTable.Rm = stats.Rm;
    tempTable.GroupCount = stats.GroupCount;
    tempTable.mean_Ead = stats.mean_Ead;
    tempTable.std_Ead = stats.std_Ead;  
    % Append the temporary table to the final results table
    final_results_Rm = [final_results_Rm; tempTable];
end
% Write the final results table for Rm to an Excel file
outputFilename_Rm = 'statistics_results_Rm_Exp2.xlsx';
writetable(final_results_Rm, outputFilename_Rm);
disp(['Rm Results are written to ', outputFilename_Rm]);
