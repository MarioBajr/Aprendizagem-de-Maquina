function [ resultLabels, M ] = sumClassifierTest( trainSamples, trainLabels, ...
                                                  testSamples, knn, hn)
         
[~, N] = size(testSamples);
M = zeros(2, N);
[~, V] = estimation(trainSamples, trainLabels, testSamples);
M = M + normalize(V);

[~, V] = Parzen(trainSamples, trainLabels, testSamples, hn);
M = M + normalize(V);

[~, V] = Nearest_Neighbor(trainSamples, trainLabels, testSamples, knn);
M = M + normalize(V);

resultLabels = zeros(1, N); 

for i = 1:N
    [m, best]       = max(M(:,i)');
    resultLabels(1, i) = best;
end

end