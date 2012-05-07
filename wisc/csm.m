function d=csm(W,s)
% Usage: d=csm(W,s)
% calculate CSM distance
% reference: D.L.Davis and D. W. Bouldin, "A cluster separation measure"
%    IEEE Trans. PAMI, vol. 1, no. 2, pp. 224-227, Apr. 1979.
% W: c X N each row is a center of a cluster
% s: c X 1 a column vector containing standard deviation of each cluster
%
% (C) 2001 by Yu Hen Hu
% created: 9/24/2001

[c,N]=size(W); 
dw=dist(W,W)+eye(c); % c X c matrix gives distance between each pair of cluster centers
s=diag(diag(s)); % make sure s is a col. vector
ds=s*ones(1,c)+ones(c,1)*s'; % c X c matrix containing sum of std dev
tmp=ds./dw; 
tmp=tmp-diag(diag(tmp)); % mask out k,k entries
d=mean(max(tmp)); 
