function [W,Covar,priors]=mlgmm(x)
% Usage: [W,Covar,priors]=mlgmm(x)
% Interactively develop Gaussian mixture model for a class of training data
% x: K x N matrix. K samples, N dimensional feature vectors
% W: K x c with c clusters
% Covar: N x N x c covariance matrices
% use netlab routines: gmm__.m, consist.m
% use mfiles: kmeansf.m, kmeantest.m, csm.m
%
% (C) 2001 by Yu Hen Hu
% created: 9/26/2001

[K,N]=size(x); er = 1e-5; 
xmean=mean(x);
itmax=min(K,30);
cont=1;
while cont==1, % while not done yet,
   c=input('Enter number of cluster to use: ');
   if isempty(c)|c<=0, 
       c=input('# of cluster must be a positive integer. Please enter again: '); 
   end
   W0=0.1*randn(c,N)+ones(c,1)*xmean;  % intialize cluster center
   [W,iter,Sw,Sb,Covar]=kmeansf(x,W0,er,itmax);
   if iter<itmax,
      disp(['Kmeans algorithm converges in ' int2str(iter) ' iterations!']);
   else
      disp('Max. # of iterations reached. Kmeans stop without converging!');
   end

   % now calling netlab to fit the centers into Gaussian mixture models
   mix = gmm(N, c, 'full');  % intiate a data structure
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
   GMM_WIDTH=1.0; % a constant 
   mix.centres=W; % initial centers derived from kmeans algorithm
   mix.covars=Covar;
   % member is a K by 1 vector with each entry between 1 and c
   for i = 1:mix.ncentres
      % Add GMM_WIDTH*Identity to rank-deficient covariance matrices
      if rank(mix.covars(:,:,i)) < mix.nin
	      mix.covars(:,:,i) = mix.covars(:,:,i) + GMM_WIDTH.*eye(mix.nin);
      end
   end
   options(1)  = -1;			% 1->Prints out error values.
   options(14) = 1000;		% Max. number of iterations.
   options(5)  = 1;     	% prevent covariance collapse
   [mix, options, errlog]  = gmmem(mix, x, options);
   NumIts=size(errlog,1);
   if NumIts == options(14)
      warning(' EM ran out of iterations!',1);
   end

   W=mix.centres;
   Covar=mix.covars;
   priors=mix.priors;
     
   % Validity of clustering using different criteria
   
   % (1) display center distance table, and variance table if c > 1
   if c > 1, 
      cdtable=dist(W,W);
      disp('the distance between cluster centers are: ')
      cdtable
      disp(['averge cluster-cluster center distance = ' ...
         num2str(sum(sum(cdtable))/(c*c-c))]);
      stdtable=[];
      for i=1:c,
         stdtable=[stdtable sqrt(sort(eig(Covar(:,:,i))))];
      end
      disp('standard deviations of each Gaussian cluster are (each column per cluster):')
      disp('last row is the ratio between smallest to largest std dev for each cluster')
      stdtable=[stdtable; stdtable(1,:)./stdtable(N,:)], % N+1 X C
   end
   
   % (2) visualize the clustered data for up to 6 clusters
   [dd,member]=kmeantest(x,W);
   % display each cluster if c <=6
   if c <=6,
       figure(1),clf
       for i=1:c,
          if c > 1, eval(['subplot(' int2str(c) '2' int2str(i) '),']), end
          imagesc(x(find(member==i),:)')
          title(['cluster # ' int2str(i)])
       end
   end
   
   % (3) evaluate clustering separations measure (CSM)
   if c > 1, 
      std=zeros(1,c);
      for i=1:c,
         std(i)=mean(sqrt(sort(eig(Covar(:,:,i))))); % std is 1 x c
      end
      gsmeasure=csm(W,std');
      disp(['Cluster separation measure: CSM(' int2str(c) ') = ' num2str(gsmeasure)]);
   end
   
   disp('Enter 0 (default) # of clusters of current class is satisfactory.');
   cont=input('Otherwise, enter 1 or other number to continue: ');
   if isempty(cont), cont=0; end
end

   
   
   
