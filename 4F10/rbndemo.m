% RBNdemo.m - RBF demonsration program using rbn.m
% copyright (C) 2000 by Yu Hen Hu
% created: March 17, 2000
% modified: Feb. 11, 2001
% call fungenf.m, cinit.m, rbn.m, gauss.m, kmeansf.m

clear all, figure(1)
% generate 2D data trainf, testf
Nr=input('# of training samples = '); 
Nt=input('# of testing samples = '); 

% generate the training and testing data samples
funtype=input('1. Sinusoids, 2. piecewise linear, or 3. polynomial. Enter choice: ');
switch funtype
   case 1  % a sinusoidal signal is to be generated
      tp=[.7 -.2]; % y = cos(4*pi*0.7*x + (-.2))
   case 2  % piecewise linear function
      tp=[-.5 0 -.1 .2 .1 .2 .3 1 .5 0];
   case 3 % polynomial specified by roots
      tp=[2 -.3 0 0.2];
   end
xgen=0;    % only regularly spaced data samples are generated
xorder=2; % training and testing data are evenly interlaced
[trainf,testf]=fungenf(Nr,Nt,xgen,funtype,tp,xorder);
x=trainf(:,1); d=trainf(:,2); 
xmean=mean(x); % xmean is 1 by n
y=testf(:,1); yd=testf(:,2);
[k,n]=size(x); % m # of samples, n: dim of feature space
   
for type=1:2,
   
% determine radial basis centers and cluster numbers
if type==1,
   xi=x; c=k;
elseif type==2;
   % decide # of radial basis functions
   figure(1),subplot(122),plot(x,d,'o'),axis square,drawnow
   c=input('number of radial basis functions used: '); 
   xi=cinit(x,2,c); % spread initial cluster center over entire range
   xi=kmeansf(x,xi,.0001,50);
end

% find weights w, and approximated curve fhat
if type==1,
   lambda=input('smoothing parameter, lambda (>=0) = ');
   [w,xi,sigma]=rbn(x,d,xi,lambda,1);
   fhat=gauss(y,xi,sigma)*w;
   %figure(1),
   subplot(121)
   plot(y,yd,'ob',y,fhat,'+b',x,d,'*r'),
   axis([min([x;y]),max([x;y]),min([yd;fhat;d]),max([yd;fhat;d])])
   legend('test samples','approximated curve','radial basis')
elseif type==2,
   lambda=0;
   [w,xi,sigma]=rbn(x,d,xi,lambda,2);
   % the rbn.m routine may change the # of clusters!
   [c,n]=size(xi);
   % note that sigma is n by n by c
   % fhat=w(1)*ones(size([x;y])); 
   fhat=gauss([x;y],xi,sigma)*w;
   fd=gauss(xi,xi,sigma)*w;
   figure(1),subplot(122)
   plot(y,yd,'ob',[x;y],fhat,'+b',x,d,'.r',xi,fd,'*r'),
   axis([min([x;y]),max([x;y]),min([yd;fhat;d;fd]),max([yd;fhat;d;fd])])
   legend('test samples','approximated curve','train samples','radial basis')
end
subplot(121),title('Type I RBN'),
subplot(122),title('Type II RBN')
end % type