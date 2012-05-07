clear % Clear Variables
clc   % Clear Console

[samples, qClass1, qClass2] = distribution(); % Create Distribution
% clustering(samples, qClass1, qClass2);        % Clustering with k-means
% estimation(samples);                          % Estimation with Maximum likehood estimation


% [W,M,V,L] = EM_GM(samples,2,[],[],1,[]);

% label = emgm(samples', 2);
% spread(samples',label);

% call the routine
[bandwidth,density,X,Y]=kde2d(samples);
% plot the data and the density estimate
contour3(X,Y,density,40), hold on
plot(samples(:,1),samples(:,2),'r.','MarkerSize',5)