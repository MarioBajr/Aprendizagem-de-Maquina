function [x,xmin,xmax]=scale(x,low,high,type)
% Usage: [x,xmin,xmax]=scale(x,low,high,type)
% 
% linearly scale x into the range of low to high 
%  it must be that high -low > 0
% if type = 0 (default), low and high are scalars and scaling is uniform in each dim
%         = 1, scaling is done at each individual dimension in the range
%              vectors low and high
% output: x - scaled x,  xmax: original maximum, xmin: original min
% input: x - original x, low: desired min, high: desired max.
% copyright (c) 1996 by Yu hen Hu
% created 9/21/96
% modified 9/22/96: add xmin, xmax to output
% modified 4/5/2001: add type to allow scaling to indivisual ranges in each dim.
% 
if nargin==3,
   type=0;
end

[K,M]=size(x);
range=high-low; % type 0, scalar, type 1, may be a 1 X M vector
if type==0,
   xmax=max(max(x));xmin=min(min(x));xrange=xmax-xmin;
   x=(x-xmin)*range/xrange+low;
elseif type==1,
   if size(high)==size(low) == [1 1];
      high=ones(1,M)*high; low=ones(1,M)*low;
   end
   
   low=diag(diag(low))'; range=diag(diag(range))'; % make them 1 x M vectors
   xmax=max(x); xmin=min(x); xrange=xmax-xmin; % each 1 x M vector
   mask=[xrange<1e-3]; % maskout elements too small, 1 X M
   range=(1-mask).*range+mask; xrange=(1-mask).*xrange+mask; 
   x=(x-ones(K,1)*xmin)*diag(range./xrange)+ones(K,1)*low;
end
