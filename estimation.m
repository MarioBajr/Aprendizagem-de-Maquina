function [classifierLabels, V] = estimation( trainSamples, trainLabels, ...
    testSamples, testLabels )

[~, paramsML] = ML(trainSamples, trainLabels, testSamples, []);
[~, paramsEM] = EM(trainSamples, trainLabels, testSamples, [1 2]);

priori1 = paramsML(1).p;
priori2 = paramsML(2).p;

paramsEM(2).p = priori2;

paramsFinal = [paramsML(1) paramsEM(2)];

[classifierLabels, V] = classify_paramteric(paramsFinal, testSamples);
classifierLabels = classifierLabels + 1;

end