function [lx,ly]=sline(w,v)
% Usage: [lx,ly]=sline(w,v)
% plot line on axix specified by v with 
%   normal vector w
% we find intersection of the line w1+w2*x+w3*y=0 with
% four lines: x=v(1), or x=v(2), v(3)<y<v(4), and
%             y=v(3), or y=v(4),  v(1)<x<v(2)
% lx,ly are the two terminal points of the intersection
% which are lx=[x1 x2], ly=[y1 y2]
% last revision: 9/25/94
% (C) copyright 1994-2001 by Yu Hen Hu

lx=[];
ly=[];
%case I.  x=v(1), or v(2), check if y is in [v(3) v(4)]
% If |w(3)| < 0.00001, then skip because almost vertical line
if abs(w(3))>1e-5
   y1=-(w(2)*v(1)+w(1))/w(3);
   if (v(3) <= y1) & (y1 <= v(4)),
      lx=[lx v(1)];
      ly=[ly y1];
   end

   y2=-(w(2)*v(2)+w(1))/w(3);
   if (v(3) <= y2) & (y2 <= v(4)),
      lx=[lx v(2)];
      ly=[ly y2];
   end
end

%case II.  y=v(3), or v(4), check if x is in [v(1) v(2)]
% If |w(2)| < 0.00001, then skip because almost vertical line
if abs(w(2))>1e-5
  x1=-(w(3)*v(3)+w(1))/w(2);
  if (v(1) <= x1) & (x1 <= v(2)),
    lx=[lx x1];
    ly=[ly v(3)];
  end

  x2=-(w(3)*v(4)+w(1))/w(2);
  if (v(1) <= x2) & (x2 <= v(2)),
    lx=[lx x2];
    ly=[ly v(4)];
  end
end
