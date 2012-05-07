function y=actfun(x,type,par)
% Usage: y=actfun(x,type,par)
% Compute activation functions
% x: net function, a K x N matrix
% y: activation function, a K x N matrix
% type: 1 - sigmoid, 2 - tanh, 3- linear, 4 - radial
% par: parameter list
%    sigmoid: T,  y=1/(1+exp(-x/T)), yp=y*(1-y)/T
%    tanh: T,     y=(exp(x/T)-exp(-x/T))/(exp(x/T)+exp(-x/T))
%                 yp=(1-y*y)/T
%    linear:m,b   y=ax+b, yp=a
%    radial:m,sig y=exp(-(x-m)^2/sig^2), yp=-2(x-m)*y/sig^2
% (C) copyright 2001 by YU HEN HU
% created: 2/5/2001

if nargin<=2,% if omitted from input vari list, set default
   if type==3,
      par=[1 0]; 
   elseif type==4,
      par=[0 1];
   else
      par=1;
   end
end
if nargin==1, % no type info either
   type=1;
end

switch type
case 1 % sigmoid
   T=par(1);
   y = 1./(1+exp(-x/T));
case 2 % tanh'
   T=par(1);
   tmp=exp(x/T);
   y=(tmp-1./tmp)./(tmp+1./tmp);
case 3 % linear'
   a=par(1); b=par(2);
   y=a*x+b;
case 4 % radial'
   m=par(1); sig=par(2);
   s=sig^2;
   tmp=(x-m).*(x-m);
   y=exp(-tmp/s);
end
