function r=autocorr(y,N,wtype,opt);
% Usage: r=autocorr(y,N,wtype,opt);
% Sample autocorrelation lags calculation 
% r=R(0:N-1)
% y: a vector
% N: # of autocorrelation lags
% wtype: types of window used
%      = 0, default: rectangular window
%      = 1, triangular window
% opt = 0  (default) make y to zero mean before finding auto-correlation lags
%     = 1  do not make y zero mean (or y is already zero mean)
% (C) 2001 by Yu Hen Hu
% created: 10/27/2001

if nargin<4, opt=0; end % converting y to zero mean
if opt==0, y=y-mean(y); end

if nargin<3, % if wtype is not specified
   wtype=0;  % use default value
end

y=diag(diag(y)); % make sure it is a column vector
len=length(y); 

if N>1,
   A=toeplitz(y,[y(1) zeros(1,N-1)]);
elseif N==1,
   A=y;
end

if wtype==0,
   % rectangular window (default) 
   r=y'*A./[len:-1:len-N+1];
elseif wtype==1, % triangular window
   r=y'*A/len;
end



