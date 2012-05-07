clear all
% generate a Gaussian mixture with distant modes
data=[randn(500,2);
  randn(500,1)+3.5, randn(500,1);];
% call the routine
[bandwidth,density,X,Y]=kde2d(data);
% plot the data and the density estimate
contour3(X,Y,density,50), hold on
plot(data(:,1),data(:,2),'r.','MarkerSize',5)