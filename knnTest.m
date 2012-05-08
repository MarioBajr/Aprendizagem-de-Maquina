function knnTest( trainSamples, trainLabels, ...
                  testSamples, testLabels )
              
k=[1 3 5 8 10 15 20];
   
for i=1:length(k)  
    knnLabels = Nearest_Neighbor(trainSamples, trainLabels, testSamples, k(i));
    [globalError, classErrors] = classifierError(testLabels, knnLabels);
    
    fprintf('\nk: %.4f\n', k(i));
    fprintf('Error Classificacao Global: %.4f\n', globalError);
    fprintf('Error Classificacao Classe 1: %.4f\n', classErrors(1));
    fprintf('Error Classificacao Classe 2: %.4f\n', classErrors(2));
    
%     drawSamples(testSamples', testLabels', knnLabels', []);
end

end
                        