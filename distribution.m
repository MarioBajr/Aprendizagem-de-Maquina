function [samples, qtdClass1, qtdClass2] = distribution()

% Classe 1
mu1 = [0 0];
sigma1 = [2^2 1.7; 1.7 1^2];
qSamples1 = 150;
% Classe 2
mu2 = [0 3];
sigma2 = [.5^2 0; 0 .5^2];
qSamples2 = 100;
% Classe 2
mu3 = [4 3];
sigma3 = [2^2 -1.7; -1.7 1^2];
qSamples3 = 50;

qtdClass1 = qSamples1;
qtdClass2 = (qSamples2 + qSamples3);

% Distribution Bivariate
samples = [mvnrnd(mu1,sigma1,qSamples1);mvnrnd(mu2,sigma2,qSamples2);mvnrnd(mu3,sigma3,qSamples3)];

end