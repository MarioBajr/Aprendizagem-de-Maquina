clear % Clear Variables
clc   % Clear Console

[samples, qClass1, qClass2] = distribution(); % Create Distribution
clustering(samples, qClass1, qClass2);        % Clustering with k-means