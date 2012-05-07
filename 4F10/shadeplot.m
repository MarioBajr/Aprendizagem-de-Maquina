% shadeplot.m - demonstrate how to plot shades over a plane in matlab
% (C) 2005 by Yu Hen Hu
% created: 9/21/2005

clear all; close all; echo on
% Let us say we want to plot the region of x + 2y >=0 over a
% 2D region -2 <= x <= 2, -3 <= y <= 3
x=[-2:0.1:2]; y=-0.5*x;
plot(x,y,'b-'),axis([-2 2 -3 3]),hold on
% the line x+ 2y = 0 intersects with the four lines 
% x = -2, x= 2, y=-3, y=3 at (-2, 1), (2, -1), (6, -3), (-6, 3) 
% where the last two points fall outside the region. In fact the
% region we want to fill is enclosed by a polygon whose coordinates
% are: [(-2 1) (-2, 3) (2, 3), (2, -1)]
fill([-2 -2 2 2],[1 3 3 -1],'g')