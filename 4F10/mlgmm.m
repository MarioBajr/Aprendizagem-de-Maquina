function [W,Covar,priors]=mlgmm(c,x)
% Usage: [W,Covar,priors]=mlgmm(c,x)
% Train Gaussian mixture model, c components, for a class of training data
% x: K x N matrix. K samples, N dimensional feature vectors
% W: K x c with c clusters
% Covar: N x N x c covariance matrices
% use netlab routines: gmm__.m, consist.m
% use mfiles: kmeansf.m, kmeantest.m, csm.m
%
% (C) 2001 by Yu Hen Hu
% created: 9/26/2001
% modified for 4F10

[K,N]=size(x); 
xmean=mean(x);
xcov=cov(x,1);
itmax=min(K,30);

W=0.1*randn(c,N)+ones(c,1)*xmean;  % intialize cluster center 

% now calling netlab to fit the centers into Gaussian mixture models
mix = gmm(N, c, 'diag');  % intiate a data structure
%	The fields in MIX are
%	  
%	  mix.type = 'gmm'
%	  mix.nin = the dimension of the space = N here
%	  mix.ncentres = number of mixture components = c here
%	  mix.covartype = string for type of variance model = 'full' here
%	  mix.priors = mixing coefficients = nj(i)/sum(nj)
%	  mix.centres = means of Gaussians: stored as rows of a matrix = W
%	  mix.covars = covariances of Gaussians

% initialize the gmm centers and covariance matrices
% GMM_WIDTH=1.0; % a constant 

% set the component means to random points
mix.centres=W; % initial centers derived from kmeans algorithm

% initialise the covariance matrices
switch mix.covar_type

case 'full'
   Covar=zeros(N,N,c);
   for i=1:c,                 % set each 
      Covar(:,:,i)=xcov; % N X N
   end; % i-loop

case 'diag'
   Covar=zeros(c,N);
   for i=1:c,                 % set each 
      Covar(i,:)=diag(xcov)'; % N 
   end; % i-loop

otherwise
  error(['Unknown covariance type ', mix.covar_type]);
end


mix.covars=Covar;

options(1)  = 1;		% 1->Prints out error values.
options(14) = 5;		% Max. number of iterations.
options(5)  = 0.0001;     	        % prevent covariance collapse

W=mix.centres;
priors=mix.priors;

% Now do the training
[mix, options, errlog]  = gmmem(mix, x, options);

W=mix.centres;
% pass back the covariance matrix as full for consistency
switch mix.covar_type
   case 'full'
      Covar=mix.covars;
   case 'diag'
      Covar=zeros(N,N,c);
      for i=1:c,
          Covar(:,:,i)=diag(mix.covars(i,:));
      end
end
priors=mix.priors;
     

   
   
   
