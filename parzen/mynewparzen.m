% xi=rand(1,1024); 
% x=linspace(-1,2,1024); 
% p=Parzen(xi,x,0.5,[]); 
% plot(x,p); 


% xi=randn(1,1024); 
% x=linspace(-2,2,1024); 
% p=Parzen(xi,x,0.5,[]); 
% plot(x,p); 
clc,clear;

figure;
hold on;

Num=10;                            
xi=mvnrnd([0 1 ],eye(2),Num)';
% x1=mvnrnd([2 0 ],2*eye(2),Num)';
% xi(2,:)=[];
x=linspace(-4,4,1024);
h1=0.4;

% % Draw Histogram
% [cdfF,cdfX] = ecdf(xi);
% [cdfN,cdfC] = ecdfhist(cdfF,cdfX); 
% bar(cdfC,cdfN);

% Draw Parzen
p=Parzen(xi,x,h1,[]); 
plot(x, p, '-r');
title('parzen  h1=0.5');

ylabel('N=10');