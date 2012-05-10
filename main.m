clear % Clear Variables
clc   % Clear Console
close all

addpath ./toolbox % Adding Toolbox to ProjectPath
addpath ./kde2d   % Adding Kde2d to ProjectPath

% q1
fprintf('Question 1\n');
[samples, labels] = distribution();                 % Create Distribution
[resultLabels, centers] = clusteringTest(samples, labels);   % Clustering with k-means

figure
hold all
plot(samples(labels==1,1),samples(labels==1,2),'ro','MarkerSize',5);% Correct class 1 => cluster 1
plot(samples(labels==2,1),samples(labels==2,2),'bo','MarkerSize',5);% Wrong   class 1 => cluster 2

drawSamples(samples, labels, resultLabels, centers);

% Draw Samples Density
[~,density,X,Y]=kde2d(samples);
figure, contour3(X,Y,density,40), hold on
plot(samples(:,1),samples(:,2),'r.','MarkerSize',5)

% q2

% Processing Train and Test Samples
[test_idx, train_idx] = make_a_draw(length(samples) * .7, length(samples));

% Convert Samples and Labels to Toolbox Matrix Format
samples = samples';
labels = labels';

% Filter Train Samples/Labels and Test Samples/Labels
trainSamples = samples(:, train_idx);
trainLabels  = labels(:, train_idx);
testSamples  = samples(:, test_idx);
testLabels   = labels(:, test_idx);

% q2.a
fprintf('\nQuestion 2.a\n');
resultLabels = estimationTest(trainSamples, trainLabels, testSamples, testLabels);
drawSamples(testSamples', testLabels', resultLabels', []);


fprintf('\nQuestion 2.b\n');
parzenTest(trainSamples, trainLabels, testSamples, testLabels);

fprintf('\nQuestion 2.c\n');
knnTest(trainSamples, trainLabels, testSamples, testLabels);

fprintf('\nQuestion 2.d\n');
[resultLabels] = sumClassifierTest(trainSamples, trainLabels, testSamples, 3, 0.4);
[globalError, classErrors] = classifierError(testLabels, resultLabels);
fprintf('Error Classificacao Global: %.4f\n', globalError);
fprintf('Error Classificacao Classe 1: %.4f\n', classErrors(1));
fprintf('Error Classificacao Classe 2: %.4f\n', classErrors(2));

% q3
[globalError, classErrors] = evaluatingClassifiers(samples, labels);
ave_score = mean(globalError);

fprintf('\nQuestion 3\n');
fprintf('V-Fold-Croo-Validation Stratified: 10 groups\n')
fprintf('Classificador Parametrico:       %.4f\n', ave_score(1));
fprintf('Classificador Parzen (h=0.4):    %.4f\n', ave_score(2));
fprintf('Classificador KNN (k=3):         %.4f\n', ave_score(3));
fprintf('Classificador Soma (h=0.4, k=3): %.4f\n', ave_score(4));