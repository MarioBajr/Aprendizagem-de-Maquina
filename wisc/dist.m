function d=dist(X,W,type,para)
% Usage: d=dist(X,W,type,para)
% X: K x M
% W: C x M
% d: K x C  distance between K 1 X M vectors and 
%                            C 1 X M prototypes
% type = 0 (default) L2 norm, para=[]
%      = 1 L1 norm, para=[]
%      = 2 L_inf norm (box distance), para=[]
%      = 3 distance taking covariance matrix into account
%          para: c x 1, para{i}: M x M inverse of cov. matrix
% (C) 2001 by Yu Hen Hu
% created: 4/5/2001, 
% modified: 9/5/2001 to add type 3 distance

if nargin <3,
   type=0; % default is L2 norm
end
if type == 3,
   if nargin < 4, error('must give covarince matrices'); end
end

[K,M]=size(X);
[C,M1]=size(W);
if M~=M1, error('X and W dimension should be the same!'); end

if type==0, % L2 norm
   if M >1,
      wnorm=sum((W.*W)');    % 1 by C vector
      xnorm=sum((X.*X)');    % 1 by K vector
   elseif M==1,
      wnorm=(W.*W)';         % 1 by C vector
      xnorm=(X.*X)';         % 1 by K vector
   end
   d=sqrt(xnorm'*ones(1,C)-2*X*W'+ones(K,1)*wnorm); % K by C  matrix 
elseif type==1, % L1 norm
   d=[];
   if C <=K, % compute by column
      for i=1:C,
         d=[d sum(abs(X'-W(i,:)'*ones(1,K)))'];
      end
   elseif K < C, % compute by row
      for i=1:K,
         d=[d; sum(abs(X(i,:)'*ones(1,C)-W'))];
      end
   end
elseif type==2, % L_inf norm
   d=[];
   if C <=K, % compute by column
      for i=1:C,
         d=[d max(abs(X'-W(i,:)'*ones(1,K)))'];
      end
   elseif K < C, % compute by row
      for i=1:K,
         d=[d; max(abs(X(i,:)'*ones(1,C)-W'))];
      end
   end
elseif type==3, % L2 norm with covariance matrix
   % (x-w)*Cinv*(x-w)'
   % calculate x-w
   d=[];
   for i=1:C,
      dxw=X-ones(K,1)*w(i,:); % K by M
      d = [d sum((para{i}*dxw').*dxw')'];
   end
end