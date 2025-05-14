clear
load("dataset.mat")
% Delete observations where Ead > 5
% dataset(dataset.Ead > 5, :) = [];
% dataset.Pmx  = [];
% dataset.Pm  = [];
% dataset.Vx  = [];
% dataset.Rx  = [];

rng("default")
% Extract the feature matrix and target vector
X = table2array(dataset(:, 4:end)); % Features
% X = mapminmax(X,-1,1);
y = dataset.Ead; % Target variable
classLabel = dataset.Ad; % Class labels
material = dataset.CF;

% Create a cvpartition object that defines the data split
cvp = cvpartition(classLabel, 'HoldOut', 0.2); % 80:20 split

% Extract the training data
X_train = X(training(cvp), :);
y_train = y(training(cvp), :);
label_train = classLabel(training(cvp), :);
material_train = material(training(cvp), :);

% Extract the test data
X_test = X(test(cvp), :);
y_test = y(test(cvp), :);
label_test = classLabel(test(cvp), :);
material_test = material(test(cvp), :);
