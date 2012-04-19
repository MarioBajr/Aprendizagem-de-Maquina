% Classe 1
mu1 = [0 0];
sigma1 = [2^2 1.7; 1.7 1^2];
samples1 = 150;
% Classe 2
mu2 = [0 3];
sigma2 = [.5^2 0; 0 .5^2];
samples2 = 100;
% Classe 2
mu3 = [4 3];
sigma3 = [2^2 -1.7; -1.7 1^2];
samples3 = 50;

% Distribution Bivariate
samples = [mvnrnd(mu1,sigma1,samples1);mvnrnd(mu2,sigma2,samples2);mvnrnd(mu3,sigma3,samples3)];

% Draw Graphic
c = [ones(samples1, 1); repmat(2, [samples2 1]); repmat(2, [samples3 1])];
scatter(samples(:,1),samples(:,2),5, c, '+');
hold on

% mu = [mu1; mu2; mu3];
% sigma = cat(3,sigma1,sigma2, sigma3);
% obj = gmdistribution(mu,sigma);
% 
% ezsurf(@(x,y)pdf(obj,[x y]),[-10 10],[-10 10])

% K-Means
opts = statset('Display','final');
[idx,ctrs] = kmeans(samples,2,...
                    'Replicates',100,...
                    'Options',opts);
                
plot(samples(idx==1,1),samples(idx==1,2),'ro','MarkerSize',5);
plot(samples(idx==2,1),samples(idx==2,2),'bo','MarkerSize',5);
plot(ctrs(:,1),ctrs(:,2),'kx','MarkerSize',10,'LineWidth',2);
plot(ctrs(:,1),ctrs(:,2),'ko','MarkerSize',10,'LineWidth',2);
legend('Cluster 1','Cluster 2','Centroids','Location','NW');