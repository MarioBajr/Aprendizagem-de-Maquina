%function p=Parzen(xi,x,h1,f)
%xi
%h1
clc,clear;
Num=2000;
    xi=mvnrnd([0 1 ],eye(2),Num)';
   % x1=mvnrnd([2 0 ],2*eye(2),Num)';
    xi(2,:)=[];
    x=linspace(-3,3,1024); 
   
 f=@(u)(1/sqrt(2*pi))*exp(-0.5*u.^2);

h1=4;
N=size(xi,2);
hn=h1/sqrt(N);
[X Xi]=meshgrid(x,xi);
p=sum(f((X-Xi)/hn)/hn)/N; 


figure;
plot(x,p,'g-');
title('parzen h1=4');
ylabel('N=2000');
%figure,plot(x1,p,'g-');