% fungen.m - generating 1D functions in [-0.5 .5]
%  Input: Nr, Nt - number of training and testing samples
%  sampling point may be randomly drawn or regular spaced.
%   sine - specifying frequency, phase
%   piecewise linear - specify end points
%   polynomial - specify coefficients
%
% copyright (c) 1996-2001 by Yu Hen Hu
% created 9/22/96
% modified: 2/12/2001
% modified: 10/24/2001 fix a bug when randomly spaced samples are generated
%   ie. when xgen=1

clear all
Nr=input(' No of training samples (even number) = '); 
Nt=input(' No. of testing samples (even number) = ');
N=Nr+Nt;  % total number of points to be generated
xgen=input('Enter 0 for regular spacing, 1 for random spacing: ');
if xgen==0,
   dN=round(1000/(N-1))*0.001;
   x=[0:dN:dN*(N-1)]'-0.5;   % x is N by 1
elseif xgen==1,
   x=sort(rand(N,1)-0.5);
end

disp(' Select on of the following functions, enter 1, 2 or 3: ');
disp(' 1. Sine function');
disp(' 2. Piecewise linear function');
disp(' 3. Polynomial');
funtype=input(' Enter your choise (1, 2, or 3): ');

if funtype==1,  % sine function
  fre=input('enter frequency (0 < f < 1) : ');
  phi=input('enter phase (between -0.5 and 0.5): ');
  y=cos((4*pi*fre*x)+phi);   %  y is N by 1
end
if funtype ==2, % piecewise linear function
   disp('enter coordinates (-0.5 and 0.5) x(i)s must be multiple of 1/100s');
   '[x(1) y(1) x(2) y(2) ... x(n) y(n)] = (-0.5 < x(1) < x(n) < 0.5) '
   p=input('remember []: ');
   npt=length(p); 
   if rem(npt,2)==1, 
      error('must have even number of points, break'); 
      break
   end
   p=reshape(p,2,npt/2); npt=npt/2;  % p is 2 by npt now
   % extend two ends to [-.5 .5]
   if p(1,1) > x(1),
      p(2,1)=(p(2,2)-p(2,1))*(x(1)-p(1,1))/(p(1,2)-p(1,1))+p(2,1);
      p(1,1)=x(1);
   end
   if p(1,npt) < x(N),
      p(2,npt)=(p(2,npt)-p(2,npt-1))*(x(N)-p(1,npt-1))/(p(1,npt)-p(1,npt-1))+p(2,npt-1);
      p(1,npt)=x(N);
   end
   x=sort(x); y=[]; n1=0;
   for i=1:npt-1,
      n2=max(find(x <= p(1,i+1)));
      tmpx=x(n1+1:n2);  n1=n2;
      y=[y;(p(2,i+1)-p(2,i))*(tmpx-p(1,i))/(p(1,i+1)-p(1,i))+p(2,i)];
   end
end   
if funtype==3,  % polynomial function
   disp('polynomial may be specified by');
   disp('1. Enter the polynomial form: a(1)x^n + a(2) x^(n-1) + ... + a(n+1), or ');
   disp('2. Enter the roots between (-0.5 and 0.5)');
   pform=input('Enter choice of 1 or 2: ');
   if pform==1,
      acoef=input('Enter [a(1) a(2) ... a(n+1)] = ');
      n=length(acoef);    
      y=acoef(1);
      if n>1,
         for i=1:n-1,
            y=y.*x+acoef(i+1);
         end
      end
   elseif pform==2,
      aroot=input('Enter [root(1) root(2) ... root(n)] = ');
      n=length(aroot);
      y=ones(size(x));
      for i=1:n,
         y=y.*(x-aroot(i));
      end
   end
end
% ask if want prediction
xorder=input('If you do not want training sequence randomized, enter 0: ');
if isempty(xorder)|xorder ~= 0, 
   tmp=randomize([x y]);
else 
   tmp=[x y]; 
end
a=tmp(1:Nr,:); save trainf a -ascii -tabs
if Nt > 0,
   b=tmp(Nr+1:N,:); save testf  b -ascii -tabs
   figure(1),plot(a(:,1),a(:,2),'o',b(:,1),b(:,2),'+');
   title('o: training data, +: testing data');
   disp(' training file is called trainf, and testing file called testf');
else
   figure(1),plot(a(:,1),a(:,2),'o'); % no testing samples
   disp(' training file is called trainf, there is no testing data set');
end



