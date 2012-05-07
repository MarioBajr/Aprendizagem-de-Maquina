% kerneldemo.m - demonstrate nonparametric density estimation in 1D
% using histogram and kernel method
% call kernel1d.m
% (C) 2001 by Yu Hen Hu
% created: 10/21/2001

clear all
disp('Demonstrate kernel based density estimation method');

% step 1. generate 1D random data
ax=[-2:0.02:2]; % x axis
lx=length(ax); 
xpos=[0 [rand(1,lx-2)>0.75] 0]; % position of data points make sure not on boundary
x=ax(find(xpos==1));
Nx=length(x);
disp(['Total ' int2str(Nx) ' data points.']);
figure(1),subplot(311),stem(ax,xpos),title('Indicators of data distribution')

% step 2. study the effect of histogram based density estimation
disp('Histogram density estimation')
subplot(312),hist(x,[-1.8:0.4:1.8]),title('Larger bin width (=0.4)')
subplot(313),hist(x,[-1.95:0.1:1.95]),title('Smaller bin width (=0.1)')

% step 3. try kernel estimation
disp('Kernel method with square kernels')
figure(2),subplot(311),stem(ax,xpos),title('Indicators of data distribution')
axis([-2.5 2.5 0 1])
% square kernel
type=0; h=0.4;
y=zeros(size(ax));
for i=1:Nx,
   y=y+kernel1d(type,[x(i) h],ax);
end
y=y/(Nx*h);
subplot(312),bar(ax,y),title(['square kernel, T = ' num2str(h)])

y=zeros(size(ax)); h=0.1;
for i=1:Nx,
   y=y+kernel1d(type,[x(i) h],ax);
end
y=y/(Nx*h);
subplot(313),bar(ax,y),title(['square kernel, T = ' num2str(h)])

% Gaussian kernel
type = 1; h = 0.1;
figure(3),subplot(311),stem(ax,xpos),title('Indicators of data distribution')
%axis([-2.5 2.5 0 1])
y=zeros(size(ax));
for i=1:Nx,
   y=y+kernel1d(type,[x(i) h],ax);
end
y=y/Nx;
subplot(312),plot(ax,y),title(['Gaussian kernel, Sigma = ' num2str(h)])

y=zeros(size(ax)); h= 0.05;
for i=1:Nx,
   y=y+kernel1d(type,[x(i) h],ax);
end
y=y/Nx;
subplot(313),plot(ax,y),title(['Gaussian kernel, Sigma = ' num2str(h)])
