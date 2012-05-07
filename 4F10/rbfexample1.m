% rbfexample1.m
% give the first example in lecture RBF (1)
% (C) 2001 by Yu Hen Hu
% created: 10/23/2001

clear all
xi=[-1 -0.5 1]';   n=length(xi);
d =[0.2 0.5 -0.5]';
x=[-3:0.02:3];
% construct the M matrix
% first find xi-xj 
M0=abs(xi*ones(1,n)-ones(n,1)*xi');

% using Gaussian radial basis function
disp('with Gaussian radial basis function, ...')
M=(1/sqrt(2*pi))*exp(-0.5*M0.*M0)
w=pinv(M)*d

type=1; % Gaussian rbf
f0=zeros(size(x)); f=[];
for i=1:3,
   para=[xi(i) 1];
   f(i,:)=w(i)*kernel1d(type,para,x);
end
f0=sum(f); 
figure(1), clf
plot(x,f(1,:),'k:',x,f(2,:),'b:',x,f(3,:),'r:',x,f0,'g.',xi,d,'r+')
title('F(x) using Gaussian rbfs')
axis([-3 3 -2 3])

disp('Press any key to continue ...'),pause

% apply triangular kernel
M=(1-M0).*[M0<=1];
w=pinv(M)*d
% now plot it.
type=2; % triangular rbf
f0=zeros(size(x)); f=[];
for i=1:3,
   para=[xi(i) 1];
   f(i,:)=w(i)*kernel1d(type,para,x);
end
f0=sum(f); 
figure(2), clf
plot(x,f(1,:),'k:',x,f(2,:),'b:',x,f(3,:),'r:',x,f0,'g.',xi,d,'r+')
title('F(x) using triangular rbfs')
axis([-3 3 -.6 .6])

disp('Press any key to continue ...'),pause

% now add lambda*eye to M to smooth it

lambda=[0 0.5 2];  g=[];
for k=1:3,
   f=zeros(3,size(x,2));
   w=pinv(M+lambda(k)*eye(n))*d;
   for i=1:3,
      para=[xi(i) 1];
      f(i,:)=w(i)*kernel1d(type,para,x);
   end
   g=[g;sum(f)]; 
end
figure(3), clf
plot(x,g(1,:),'c.',x,g(2,:),'g.',x,g(3,:),'m.',xi,d,'r+')
legend(['lambda = ' num2str(lambda(1))],['lambda = ' num2str(lambda(2))],...
   ['lambda = ' num2str(lambda(3))],'data points')
title('Effect of regularization')
axis([-3 3 -0.6 0.6])


   
   