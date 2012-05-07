function y=gauss(x,xi,si)
% Usage: y=gauss(x,xi,si)
% c-th radial basis neuron
% x: k by m input, each row is a sample
% xi: c by m, c clustering centers
% si: m by m by c: c covariance matrices, or 
%     1 by c or c by 1: variance vector
% y: k by c output
% y(i,j) = exp(-0.5*((x(i,:)-xi(j,:))*inv(si)*(x(i,:)-xi(j,:))')
% 
% (C) copyright 2001 by Yu Hen Hu
% created 2/19/2001
% Modified: 6/28/2001

[k,m]=size(x);
[c,mi]=size(xi); 
sdim=size(si);

if m~=mi,
   error('dim of x should = dim of xi');
end

if c == 1, % only one center, si should be square or scalar, sdim=[m m]
   if sdim(1)~=sdim(2),
      error('si should be a scalar or square matrix')
   elseif sdim(1)==1, % sdim(2) == 1 as well, si is a scalar
      psi(:,:,1)=(1/si)*eye(m);
   else % si is a square matrix, and dimension > 1
      psi(:,:,1)=pinv(si);
   end
elseif c > 1, % si should be (m by m by c) or (1 by c  or c by 1)
   if length(sdim)==3, % m by m by c
      if sdim(3) ~= c,
         error('si should have same number of centers as xi');
      else % sdim(3)=c, it must be sdim(1)=sdim(2)=m!
         if sdim(1)~=sdim(2),
            error('si(.,.,c) should be a square matrix or si should be a vector')
         end
         for i=1:c,
            psi(:,:,i)=pinv(si(:,:,i));
         end
      end
   else % length(sdim)=2, si(i) is a vector 1 by c or c by 1
      if min(sdim(1:2))>1,
         error('si must be a vector');
      end
      for i=1:c,
         psi(:,:,i)=(1/si(i))*eye(m);
      end
   end
end
% the result of above is that si is a m by m by c matrix
M=[];            
for i=1:c
   tmp=x-ones(k,1)*xi(i,:);  % x-m(i)
   M=[M -0.5*diag(tmp*psi(:,:,i)*tmp')]; % augment a K by 1 vector
end
y=exp(M);