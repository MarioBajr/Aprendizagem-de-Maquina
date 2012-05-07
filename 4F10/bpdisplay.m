% bpdisplay.m
% display training error of bpnew.m
% (C) copyright 2001 by Yu Hen Hu
% created: 3/19/2001

if rem(t,ndisp)==0,  % update plots every ndisp epochs
   xax=[max(1,t-999):t]; % x-axis
   figure(1),plot(xax,E(xax)),
   title(['training error (epoch size = ' int2str(K) ')'])
   xlabel('epoch'),ylabel('error'),drawnow
end

