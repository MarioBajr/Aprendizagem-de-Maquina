function [ resultLabels, M ] = sumClassifierTest( trainSamples, trainLabels, ...
                                                  testSamples, testLabels )
             
M = zeros(2, length(testLabels));
[~, V] = estimation(trainSamples, trainLabels, testSamples, testLabels);
M = M + normalize(V);

[~, V] = Parzen(trainSamples, trainLabels, testSamples, .4);
M = M + normalize(V);

[~, V] = Nearest_Neighbor(trainSamples, trainLabels, testSamples, 15);
M = M + normalize(V);

N = length(testLabels);
resultLabels = zeros(1, N); 

for i = 1:N
    [m, best]       = max(M(:,i)');
    resultLabels(1, i) = best;
end

end