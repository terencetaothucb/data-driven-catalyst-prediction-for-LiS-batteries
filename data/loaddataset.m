%% load dataset
clear
% Define the range to read from the excel file
range = 'A3:R151'; % Adjust the end row according to your dataset

% Specify the options for the import
opts = detectImportOptions('dataset.xlsx', 'Range', range);

% Read the data
dataset = readtable('dataset.xlsx', opts);

save("dataset","dataset")
%% load validation
clear
% Define the range to read from the excel file
range = 'A3:R2390'; 

% Specify the options for the import
opts = detectImportOptions('validation.xlsx', 'Sheet', 'All', 'Range', range);

% Read the data
validation = readtable('validation.xlsx', opts);
save("validation","validation")