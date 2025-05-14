% Clear the workspace and load data
clear
load("validation.mat")
load("y_valid_pred.mat")

% Filter the validation data
index = strcmp(validation.Ad, 'Li2S2');
validation = validation(index, :);
validation.Pmx = [];
candidates = validation.CF;
candidates_mat = validation.Mat;
Y = y_valid_pred(index, :);

% Define your class center and error ranges
peak_center =  2.747;
error_ranges = [0.3, 0.2, 0.1, 0.05, 0.03, 0.01];

% File name for Excel export
filename = 'filtered_candidates_before_expert.xlsx';

% Loop through each error range
for i = 1:length(error_ranges)
    % Define the lower and upper bounds for the error range
    lower_bound = peak_center - error_ranges(i);
    upper_bound = peak_center + error_ranges(i);

    % Filter candidates, candidates_mat, and y_valid_pred
    index = (Y >= lower_bound) & (Y <= upper_bound);
    candidates_range = candidates(index);
    candidates_mat_range = candidates_mat(index);
    y_valid_pred_range = Y(index);

    % Create table for the range
    tbl_range = table(candidates_range, candidates_mat_range, y_valid_pred_range);

    % Export to Excel with range value in sheet name
    sheet_name = sprintf('Range%d_%.4f', i, error_ranges(i));
    if i == 1
        writetable(tbl_range, filename, 'Sheet', sheet_name);
    else
        writetable(tbl_range, filename, 'Sheet', sheet_name, 'WriteMode', 'append');
    end
end
