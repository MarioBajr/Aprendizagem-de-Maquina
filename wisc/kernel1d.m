function h=kernel1d(type,para,ax)
% Usage: h=kernel1d(type,para,ax)
% return 1d vector that represent a particular type kernel
% type = 0 (default) square  h((|x-x0|) = 1 for |x-x0| <= T/2, 0 elsewhere
%        parameter: x0: center (default = 0), T: width (default = 1)
%        x0 = para(1), T = para(2)
%      = 1 Gaussian, h(|x-x0|) = (1/(sqrt(2pi)*sigma))*exp(-0.5*(x-x0)^2/sigma^2)
%        parameter: x0: center (default = 0), sigma: standard dev (default = 1)
%        x0 = para(1), sigma2 = para(2)
%        ******** Note: in some definitions, the gaussian kernel does NOT have
%        ******** the term 1/sqrt(2*pi*sigma^2) in front of it!
%        para(3) = 0 (or omitted): with the term, para(3)=1: no such term
%      = 2 triangular, h(|x-x0|) = 1 - |x-x0| for 0<=|x-x0|<T, = 0 o.w.
%      = 3 multi-quadric, h(|x-x0|)=sqrt(c^2+|x-x0|^2)  para=[x0, c]
%      = 4 inverse multiquadrics, h(|x-x0|)=1/sqrt(c^2+|x-x0|^2)  para=[x0, c]
% ax: axis the kernel is to be evaluated, a vector, default [-1:0.01:1];
% (C) 2001 by Yu Hen Hu
% created 10/21/2001

if nargin < 3, ax=[-1:0.01:1]; end
if nargin < 2, para=[0 1]; end

switch type,
case 0, % square kernel
   x0=para(1); T=para(2); 
   h=[abs(ax-x0)<=0.5*T];
case 1, % Gaussian kernel
   x0=para(1); sigma=para(2); if length(para)==2, para(3)=0; end
   if para(3)==0,
      h=(1/(sqrt(2*pi)*sigma))*exp(-0.5*(ax-x0).^2/sigma^2);
   elseif para(3)==1,
      h=exp(-0.5*(ax-x0).^2/sigma^2);
   end
case 2, % triangular kernel
   x0=para(1); T=para(2);
   h=[1-abs(ax-x0)].*[abs(ax-x0)<=T];
case 3, % multi-quadrics
   x0=para(1); c=para(2);
   h=sqrt(c^2+(ax-x0).^2);
case 4, % inverse multi-quadrics
   x0=para(1); c=para(2);
   h=ones(size(ax))./sqrt(c^2+(ax-x0).^2);
end
