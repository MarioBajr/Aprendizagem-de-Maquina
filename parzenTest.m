function parzenTest( trainSamples, trainLabels, ...
                     testSamples, testLabels )

hn = [0.1 0.4 1 5 10 20 50];

for i=1:length(hn)   
    parzenLabels = Parzen(trainSamples, trainLabels, testSamples,hn(i));
    
    [globalError, classErrors] = classifierError(testLabels, parzenLabels);
    
    fprintf('\nhn: %.4f\n', hn(i));
    fprintf('Error Classificacao Global: %.4f\n', globalError);
    fprintf('Error Classificacao Classe 1: %.4f\n', classErrors(1));
    fprintf('Error Classificacao Classe 2: %.4f\n', classErrors(2));
    
    drawSamples(testSamples', testLabels', parzenLabels', []);
end

end