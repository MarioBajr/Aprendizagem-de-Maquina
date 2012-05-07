% LMSdemo Algorithm example
% copyright (c) 1996 by Yu Hen Hu
% created 9/17/96
% last modification: 9/3/2001

clear all
% generate a time series y(n) = sin(2*pi*n*w0+phi)+epsilon(n)
N=input('length of sequence N = ');randn('seed',sum(100*clock));
w0=0.001;  phi=0.1;
d=sin(2*pi*[1:N+2]*w0+phi);
y=d+randn(1,N+2)*0.2;
x=[y(1:N);y(2:N+1);y(3:N+2)];
randn('seed',sum(100*clock)); w=[randn(3,1) zeros(3,N)]; % 3 x N+1
eta=input('eta = ');
for i=1:N,
   e(i)=d(i)-w(:,i)'*x(:,i);
   w(:,i+1)=w(:,i)+eta*e(i)*x(:,i);
end
yd=sum(w(:,1:N).*x);  % 1 by N, output of LMS filter
ax=[1:N]; bx=[3:N+2];
clf, figure(1)
subplot(221),plot(ax,w(1,ax+1)),ylabel('w0')
subplot(222),plot(ax,w(2,ax+1)),ylabel('w1')
subplot(223),plot(ax,w(3,ax+1)),ylabel('w2')
subplot(224),plot([1:N],e),ylabel('error')
figure(2)
subplot(311),plot(ax,y(bx),':g',ax,d(bx),'r'),ylabel('noisy y')
title('noiseless output (red), noisy output (1), filtered output (2), and error')
axis1=axis; 
subplot(312),plot(ax,yd,':g',ax,d(bx),'r'),ylabel('filtered y'),axis(axis1);
subplot(313),plot(ax,abs(y(bx)-d(bx)),'g',ax,abs(yd-d(bx)),'b')
ylabel('|d - y|');legend('original noise','filtered noise')
