% Plot results
figure('Position', [10 10 900 900])
%%
subplot(2, 2, 1);
hold on;
% Average results
errorbar(y_train, YfitTrainEnsembleAvg, YfitTrainEnsembleUncertaintiesAvg,...
    'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue', 'Color', 'blue'); 
errorbar(y_test, YfitTestEnsembleAvg, YfitTestEnsembleUncertaintiesAvg,...
    'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red', 'Color', 'red'); 
h = title(['Average: MSE(Train): ',num2str(mseTrain),'  MSE(Test): ',num2str(mseTest)],Interpreter="none");
h.Units = 'normalized';
h.Position(2) = h.Position(2) + 0.05;
%%
subplot(2, 2, 2);
hold on;
% Best model results
errorbar(y_train, YfitTrainBest, YfitTrainBestUncertainties,...
    'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue', 'Color', 'blue'); 
errorbar(y_test, YfitTestBest, YfitTestBestUncertainties,...
    'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red', 'Color', 'red'); 
h=title(['Best: MSE(Train): ',num2str(mseTrainBest),'  MSE(Test): ',num2str(mseTestBest)],Interpreter="none");
h.Units = 'normalized';
h.Position(2) = h.Position(2) + 0.05;
%%
subplot(2, 2, 3);
hold on;
% Worst model results
errorbar(y_train, YfitTrainWorst, YfitTrainWorstUncertainties,...
    'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue', 'Color', 'blue'); 
errorbar(y_test, YfitTestWorst, YfitTestWorstUncertainties,...
    'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red', 'Color', 'red'); 
h=title(['Worst: MSE(Train): ',num2str(mseTrainWorst),'  MSE(Test): ',num2str(mseTestWorst)],Interpreter="none");
h.Units = 'normalized';
h.Position(2) = h.Position(2) + 0.05;
%%
subplot(2, 2, 4);
hold on;
% Absolute errors
c1=[116,177,86]/255;c2=[107,157,198]/255;c3=[89,93,93]/255;
sz=50;
scatter(1:length(y_train), (y_train - YfitTrainEnsembleAvg),sz,c1,"filled","s");
hold on;
scatter(1:length(y_train), (y_train - YfitTrainBest),sz,c2,"filled","s");
hold on;
scatter(1:length(y_train), (y_train - YfitTrainWorst),sz,c3,"filled","s");
hold on;
scatter(1:length(y_test), (y_test - YfitTestEnsembleAvg),sz,c1,"filled","d");
hold on;
scatter(1:length(y_test), (y_test - YfitTestBest),sz,c2,"filled","d");
hold on;
scatter(1:length(y_test), (y_test - YfitTestWorst),sz,c3,"filled","d");

legend('AverageTrain', 'BestTrain', 'WorstTrain',...
    'AverageTest', 'BestTest', 'WorstTest',Location='southoutside');
xlabel('Sample index');
ylabel('Absolute error');
h=title('Absolute errors for different models');
h.Units = 'normalized';
h.Position(2) = h.Position(2) + 0.05;
for i = 1:3
    subplot(2, 2, i);
    gray = [0.6,0.6,0.6];
    rl = refline(1, 0); % add reference line
    rl.Color = gray;
    rl.LineStyle="--";
    legend('Training', 'Testing',Location='northwest');
    xlabel('True labels');
    ylabel('Predicted labels');
end
