% mlpdemo1.m - demonstration of feedforward network
% call MLP2.m
% (C) 2001 by Yu Hen Hu
% 
clear all, clf

% enter hidden layer weight matrix: (1st col is bias)
w1=[1 5 -5; -3 2 5; 4 -5 -1];
w2=[-2.5 1 1 1];

% part (a) 
for i=1:3,
   [lx(i,:),ly(i,:)]=sline(w1(i,:),[0 1 0 1]);
end
figure(1),
plot(lx(1,:),ly(1,:),lx(2,:),ly(2,:),lx(3,:),ly(3,:))
title('hyperplanes of the 3 hidden neurons')
axis equal

% Part (b)
% generate regular grid as testing sample data points
scale=1; nint=20;
tmp=[0:1/nint:1]'*scale;
x=[];
for i=1:nint+1,
   x=[x; tmp(i)*ones(nint+1,1) tmp];
end

% # output N=1, # hidden node H = 3, temperature = 0.1
z=reshape(mlp2(x,w1,w2,1,3,0.5),nint+1,nint+1);
[xa,ya]=meshgrid(tmp,tmp);
figure(2)
surf(xa,ya,z)
title('MLP demo1: nonlinear mapping')
