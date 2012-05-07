function [classifierLabels] = estimationTest( trainSamples, trainLabels, ...
                                              testSamples, testLabels )

[~, paramsML] = ML(trainSamples, trainLabels, testSamples, []);    
[~, paramsEM] = EM(trainSamples, trainLabels, testSamples, [1 2]);

priori1 = paramsML(1).p;
priori2 = paramsML(2).p;

paramsEM(2).p = priori2;

paramsFinal = [paramsML(1) paramsEM(2)];

classifierLabels = classify_paramteric(paramsFinal, testSamples);
classifierLabels = classifierLabels + 1;

posteriori1 = length(find(classifierLabels==1))/length(classifierLabels);
posteriori2 = length(find(classifierLabels==2))/length(classifierLabels);

[globalError, classErrors] = classifierError(testLabels, classifierLabels);

fprintf('Priori Classe 1: %f\n', priori1);
fprintf('Priori Classe 2: %f\n', priori2);
fprintf('Posteriori Classe 1: %f\n', posteriori1);
fprintf('Posteriori Classe 2: %f\n', posteriori2);

fprintf('Error Classificacao Global: %.4f\n', globalError);
fprintf('Error Classificacao Classe 1: %.4f\n', classErrors(1));
fprintf('Error Classificacao Classe 2: %.4f\n', classErrors(2));


end