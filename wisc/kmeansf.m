function [W,iter,Sw,Sb,Cova]=kmeansf(X,W,er,itmax,tp)
% Usage: [W,iter,Sw,Sb,Cova]=kmeansf(X,W,er,itmax,tp)
% k-means clustering algorithm (function call version)
% Input -  W: initial weight vectors  c by N matrix, c: # of clusters
%       -  X: K by N input vectors to be clustered
%       -  er: 0<er<1, fractional error between successive 
%              distortion for convergence. If not specified, 
%              default = 0.01
%       -  itmax: maximum iterations before terminate iterations
%              if not specified, default value = c: # of clusters
%       -  tp: a parameter vector.
%          2/23/2001: tp(1) = 0 using fixed # of clusters
%                           = 1 may delete some empty clusters at the end
%          9/21/2001: tp(2) = 0 L2 norm (default)
%                           = 1 L1 norm
%                           = 2 L_inf norm
% Output - W: final weight vectors (code book)
%        - iter: actual number of iterations to converge
%        - Sw: within cluster scatter matrix
%        - Sb: between cluster scatter matrix
%        - Cova: N X N X c covariance matrix of each clusters
%          for Sw, Sb, refer to Dudda and Hart (1974), sec. 6.8.3 pp221
% assume L2 norm distance for the time being.
% copyright (c) 1994-1996  by Yu Hen Hu 
% created: 11/2/94
% Last update:  10/16/96
% Last modified 4/25/99  adding iter, Sw, Sb as part of output.
% modified: 3/13/99  add the case c = 1
% modified: 2/23/2001 add provisions to handle empty clusters
% modified: 9/21/2001 to use dist.m to allow different distance types
% modified: 9/24/2001 to add covariance matrix of each cluster.

[c,N]=size(W);
[K,N1]=size(X);
if N~=N1, error('W and X should have the same number of columns!'); end

if nargin < 5,
   tp=[0 0];
elseif length(tp)==1, % tp(2) not specified
   tp=[tp 0];
end
dtype=tp(2);

if nargin < 4, % if itmax not specified
   itmax=c;
end
if nargin < 3, % if error is not specified either
   er=0.01;
end

if c==1,
   disp('only one cluster');
   iter=1; Sb=zeros(N); D=0;
   if N==1,
      W=X;
      Sw=0;
   elseif N > 1,
      W=mean(X);
      tmp=X-ones(K,1)*W;
      Cova=tmp'*tmp/K;
      Sw=K*Cova;
   end
   return
end % the case of c > 1 will continue

converged=0;   % reset convergence condition to false
Dprevious=0;
iter=0;

while converged==0,
   iter=iter+1;

   % step A. evaluation of distortion using dtype norm
   tmp=dist(X,W,dtype);    % K x C
   [tmp1,ind]=sort(tmp');  % first row of ind gives new cluster assignment 
   % of each data vector, tmp1, ind: 1 X K

   % step B. compute total distortion with present assignment and check for 
   %         convergence.  If converged, we still update weights one more time!
   if dtype==0, % L2 norm
      Dpresent=sum(tmp1.*tmp1);    % distortion before weight is adjusted.
   elseif dtype==1, % L1 norm
      Dpresent=sum(tmp1);
   elseif dtype==2, % L_Inf norm
      Dpresent=max(tmp1);
   end
   
   if abs(Dpresent-Dprevious)/abs(Dpresent) < er | iter == itmax,
      converged=1;
   end

   % Step C. update weights (code words) with new assignment
   if tp(1)==1, cidx=[1:c]; end
   for i=1:c,                 
      nc(i)=sum([ind(1,:)==i]);
      if nc(i)>1,
         W(i,:)=sum(X(ind(1,:)==i,:))/nc(i);  
      elseif nc(i)==1,
         W(i,:)=X(ind(1,:)==i,:);
      elseif nc(i)==0,
         if tp(1)==0, % if must have n non-empty clusters
            [tmp1,midx]=sort(-tmp1); % sort samples according to negative distance 
            % from their current center. THe most remote ones come first
            W(i,:)=X(midx(i),:); % if an empty cluster reassign it 
            % to the i-th most remote samples
         elseif tp(1)==1, % if empty clusters can be eliminated,
            cidx=setdiff(cidx,i);
         end
      end
   end % i-loop

   if tp(1)==1, % remove clusters that are empty if instructed so
      W=W(cidx,:);
      c=length(cidx);
   end

   Dprevious=Dpresent;
end % while loop


% optional procedure to calculate within cluster scatter matrix Sw and
% between cluster scatter matrix Sb

if K > 1, 
   xmean=mean(X);
else
   xmean=X;
end

Sw=zeros(N,N); Sb=Sw; Cova=zeros(N,N,c);
for i=1:c,                 % update code words
   idx=find(ind(c,:)==i);     % index of samples belong to cluster i
   nj(i)=length(idx);
   tmp=X(idx,:)-ones(length(idx),1)*W(i,:); % (x_k-m_i)^t, nj(i) X N
   if nj(i) > 0,
      Cova(:,:,i)=tmp'*tmp/nj(i); % N X N
   end   
   Sw=Sw+nj(i)*Cova(:,:,i); % Sw is N by N
   Sb=Sb+nj(i)*(W(i,:)-xmean)'*(W(i,:)-xmean); % Sb is N by N
end % i-loop
