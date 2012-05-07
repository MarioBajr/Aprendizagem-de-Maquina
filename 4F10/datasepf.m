function [data,m]=datasepf(n,n1,pn,m)
%  callable function version of the mfile datasep.m: 
%  generate linearly separable dataset on 2D 
% (C) copyright 2000-2001 by Yu Hen Hu
% created: 2/18/2000, modified 2/3/2001
% the data are between (0, 0) and (1,1)
% the data are distributed uniformly over the range.
% The center of line will pass through (.5,.5)
% user supply the slope of the line
% n=# of samples; n1=# of class 1 samples, n0=n-n1=# of class 0 samples
% by default, if n1 is not given, n1=n2=n/2
% pn = 0 (default), class labels = {0, 1}, pn = 1 , class labels = {-1, +1}
% can not control how many positive and negative examples each
% x=data locations, t=target values (-1, +1), data = [x t]
% each line consists of one x and one t
% m = slope of the separating straight line, the line funciton is
% y = mx + (1-m)/2
% data files are sorted such that class 1 samples are listed first
% and followed by class 0 samples.
% Modified: 11/23/2003 if slope is specified in input argument, it will 
%  not be asked during execusion of the program

if nargin<3,
   pn=0; % default target label is 0, +1
end
if nargin<2, % n1 is not specified
   n1=ceil(n/2); n0=floor(n/2);
else
   n0=n-n1;
end

if nargin<4, % m is not specified
   m=input('slope of the line is (default = 0.4): ');
   if isempty(m), m=0.4; end
end

% g(x) = 0.5(1-m)+mx-y=w(1) + w(2)*x + w(3)*y 
[lx,ly]=sline([0.5*(1-m) m -1],[0  1  0  1]);

rand('state',sum(100*clock)); % initialize random generator
done=0; done0=0; done1=0;
n = (n0+n1)*3;                % genreate 3 times as many as needed
                              % to ensure each class has enough
while done==0, %while not done yet,
   x=rand(n,2);  % data
   t=sign(m*x(:,1)-x(:,2)+.5*(1-m));
   if done1==0,
      idx1=find(t==+1); len1=length(idx1);
      if len1 >= n1, % enough positive samples generated,
         x1=x(idx1(1:n1),:); t1=t(idx1(1:n1),:);
         done1=1;
      else
         done1=0;
      end
   end
   if done0==0,
      idx0=find(t==-1); len0=length(idx0);
      if len0 >= n0, % enough positive samples generated,
         x0=x(idx0(1:n0),:); t0=t(idx0(1:n0),:);
         done0=1;
      else
         done0=0;
      end
   end
   if done0+done1 == 2,
      done=1;
      x=[x1;x0]; t=[t1;t0];
   else
      n=n+n; % generate more data
   end
end
if pn==0,
   t=0.5*(1+t);
end
[tsort,tidx]=sort(t);
data=[x(tidx,:) tsort];
