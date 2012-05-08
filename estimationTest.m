function [classifierLabels] = estimationTest( trainSamples, trainLabels, ...
                         testSamples, testLabels )

[classifierLabels, V] = estimation(trainSamples, trainLabels, testSamples, testLabels);

[globalError, classErrors] = classifierError(testLabels, classifierLabels);
% posteriori1 = length(find(classifierLabels==1))/length(classifierLabels);
% posteriori2 = length(find(classifierLabels==2))/length(classifierLabels);

% fprintf('Priori Classe 1: %f\n', priori1);
% fprintf('Priori Classe 2: %f\n', priori2);
% fprintf('Posteriori Classe 1: %f\n', posteriori1);
% fprintf('Posteriori Classe 2: %f\n', posteriori2);

fprintf('Error Classificacao Global: %.4f\n', globalError);
fprintf('Error Classificacao Classe 1: %.4f\n', classErrors(1));
fprintf('Error Classificacao Classe 2: %.4f\n', classErrors(2));


end