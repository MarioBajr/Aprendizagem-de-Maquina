clear % Clear Variables
clc   % Clear Console

addpath ./toolbox % Adding Toolbox to ProjectPath
addpath ./kde2d   % Adding Kde2d to ProjectPath

% q1
fprintf('Question 1\n');
[samples, labels] = distribution();                 % Create Distribution
[cLabels, centers] = clusteringTest(samples, labels);   % Clustering with k-means
drawSamples(samples, labels, cLabels, centers);

% Draw Samples Density
[bandwidth,density,X,Y]=kde2d(samples);
figure, contour3(X,Y,density,40), hold on
plot(samples(:,1),samples(:,2),'r.','MarkerSize',5)

% q2

% Processing Train and Test Samples
qSamples = length(samples);
qTrain = qSamples * .70;
[test_idx, train_idx] = make_a_draw(qTrain, qSamples);

% Convert Samples and Labels to Toolbox Matrix Format
samplesT = samples';
labelsT = labels';

% Filter Trian Samples/Labels and Test Samples/Labels
trainSamples = samplesT(:, train_idx);
trainLabels  = labelsT(:, train_idx);
testSamples  = samplesT(:, test_idx);
testLabels   = labelsT(:, test_idx);

% q2.a
fprintf('\nQuestion 2.a\n');
[resultLabels] = estimationTest(trainSamples, trainLabels, testSamples, testLabels);
drawSamples(testSamples', testLabels', resultLabels', []);

fprintf('\nQuestion 2.b\n');
parzenTest(trainSamples, trainLabels, testSamples, testLabels);

fprintf('\nQuestion 2.c\n');
knnTest(trainSamples, trainLabels, testSamples, testLabels);

fprintf('\nQuestion 2.d\n');

