%perceptron.m - perceptron learning algorithm
% INput: train(:,1:M) - pattern  train(:,M+1) - target
% Output: weight vector w=[w0 w1 ... wM], w0: bias
%     actual output vector y
% Need to call m-file routine: datasepf.m, sline.m
% copyright (C) 1996-2001 by Yu Hen Hu
% Modified: 2/9/2000, 2/3/2001, 9/10/2008
% K2: # of training samples
% M: feature space dimension

clear all, clf

gdata=input('Enter 0 to load a data file, Return to generate separable data: ');
if isempty(gdata)|gdata~=0,
   % generate random training data
   % K2=input('number of training samples = ');
   K2=50;    % set default # of training samples
   [orig,slope]=datasepf(K2);   % slope is the slope of separating plane
   % that has the formula:  y = slope*x + 0.5*(1-slope)
elseif gdata==0, % load a data file
   [F1,P1] = uigetfile('*.txt','Please Choose the input file ');
   filename = strcat(P1,F1);
   disp(['filename = ' filename]);
   tmp=load(filename);
   orig=tmp; clear F1 P1 filename tmp;
end
[Km,Kn]=size(orig);
M=Kn-1;  % number of inputs
K0=sum([orig(:,Kn)==0]);  K1=Km-K0;  K2=K0+K1;% # of targets = 0 and 1 

mdisplay=10; % # of displaying hyperplane before checking for stopping 

% Initial hyperplane
% w=[rand(1,M) 0];  % initial random weights
% The initial hyperplane can be estimated as a hyperplane separating
% a pair of data sample with different labels
% in orig, this is the first and the last data sample since there are
% only two classes and sorted according to class labels
% the separating hyperplane of two points a and b 
% has the normal vector  [-0.5(|b|^2-|a|^2) b-a]
wa=orig(1,1:M); wb=orig(K2,1:M);
wmag=0.5*(wb*wb'-wa*wa');
wunit=wb-wa;
w=[-wmag wunit(1) wunit(2)];

figure(1)
subplot(1,2,2),plot(orig(1:K1,1),orig(1:K1,2),'*',orig(K1+1:K2,1),orig(K1+1:K2,2),'o')
axis('square');
v=axis;
[lx,ly]=sline(w,v);
subplot(1,2,1),plot(orig(1:K1,1),orig(1:K1,2),'*',...
   orig(K1+1:K2,1),orig(K1+1:K2,2),'o',lx,ly)
axis('square');
title('Initial hyperplane')
converged=0;

% 0 < eta < 1/x(k)_max.
etamax=sqrt(max(orig(:,1).*orig(:,1)+orig(:,2).*orig(:,2)));
eta=input(['0 < eta < ' num2str(etamax) ', default = ' ...
    num2str(0.05*etamax) ', Enter eta = ']);
if isempty(eta), eta=0.1; end
epoch=0;
while converged==0, % not converged yet
   train=randomize(orig);
   for i=1:K2,
     y(i)=0.5*(1+sign(w*[1;train(i,1:M)']));
     w=w+eta*(train(i,M+1)-y(i))*[1 train(i,1:M)];
     [lx,ly]=sline(w,v);
     subplot(1,2,2),plot(orig(1:K1,1),orig(1:K1,2),'*g',...
        orig(K1+1:K2,1),orig(K1+1:K2,2),'og',lx,ly,'-',...
        train(i,1),train(i,2),'sr');
     axis('square');
     pause(0.1)
     drawnow
   end % for loop
   epoch=epoch+1;
   if sum(abs(train(:,M+1)-y'))==0, % check if converged
      converged=1;
   end
   if rem(epoch,mdisplay)==0,
      converged=input('type 1 to terminate, Return to continue : ')
      if isempty(converged),
          converged=0;
      end
   end
   if converged==1,
      [lx,ly]=sline(w,v);
      subplot(1,2,2),plot(orig(1:K1,1),orig(1:K1,2),'*',...
         orig(K1+1:K2,1),orig(K1+1:K2,2),'o',lx,ly)
      axis('square');
      title('final hyperplane location')
   end
end % while loop
