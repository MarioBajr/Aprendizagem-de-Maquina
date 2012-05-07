function [w,yhat]=polyfit1d(x,y,np);
% Usage: [w,yhat]=polyfit1d(x,y,np);
% finding weights of fitting a 1D polynomial of order np
% x: coordinates (column vector)
% y: noisy observation (column vector)
% w: np+1 x 1 weight vector
% (C) 2001 by Yu Hen Hu
% created: 8/30/2001

[m,n]=size(x); % x should be a column vector
% m is # of training samples
if m < np, % too few data
   error('# of samples smaller than polynomial order')
end

if np<0,
   error('polynomial order np should >= 0');
elseif np==0, % 0-th order polynomial
   xmat=ones(m,1);
elseif np>=1,
   xmat=ones(m,1);
   for i=1:np,
      xmat=[xmat x.^i];
   end
end

% xmat*w = y, w: np+1 x 1 vector
w=pinv(xmat)*y;
yhat=xmat*w;