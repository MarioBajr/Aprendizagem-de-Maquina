% mldemo.m - clustering algorithm demonstration program
% mfiles used: datagen.m, mlgmm.m
% (C) copyright 2001 by Yu Hen Hu
% created: 9/26/2001

clear all, clf
disp('Enter 1 (default) to use synthesized data set;')
disp('Enter 2 to use Iris data set.')
chos=input('Enter your choice of data sets: ');
if isempty(chos), chos=1; end
if chos==1.
   % generate some data using datagen.m
   % Nvec: (1xclass) # data in each of the c gaussian distr.
   % mean_var: Each column is a cluster
   %   row #1 and #2: coordinates of cluster centers
   %   row #3:        variance of both dimension, or dimension #1 if there is 4-th row
   %   row #4:        variance of another dimension
   %   row #5:        rotation angle is in [0  90] degrees
   Nvec=[30 30 30];
   mean_var=[...
   0.2   0.2   1.0
   0.2   1.2   0.8
   0.05  0.08  0.1
   0.2   0.2   0.1
   60    60     0];
   fr=datagen(Nvec,mean_var,1); % fr is 300 x 5, training data
   ft=datagen(Nvec,mean_var,1); % ft is 300 x 5, testing data
   Pr=fr(:,1:2); Tr=fr(:,3:5)*[1 0; 0 1; 0 1]; % combine cluster 2 and 3 into one class
   Pt=ft(:,1:2); Tt=ft(:,3:5)*[1 0; 0 1; 0 1]; % combine cluster 2 and 3 into one class
   Wtrue=mean_var(1:2,:)';
   figure(2),plot(Pr(find(Tr(:,1)==1),1),Pr(find(Tr(:,1)==1),2),'.g',...
      Pr(find(Tr(:,2)==1),1),Pr(find(Tr(:,2)==1),2),'.b',Wtrue(:,1),Wtrue(:,2),'or')
   legend('class 1','class 2','True cluster centers')
   clear fr ft
elseif chos==2,
   load iris_tra; load iris_tes; % load training and testing file
   % feature dimension = 4, target dimension = 3
   Pr=iris_tra(:,1:4); Tr=iris_tra(:,5:7);
   Pt=iris_tes(:,1:4); Tt=iris_tes(:,5:7);
   disp('using Iris data set, feature dimension = 4, 3 classes');
   clear iris_tra iris_tes
end

[Cen,cinv,clabel,nc,ppri]=mltrainnew(Pr,Tr);
[class,conf]=mltestnew(Pt,Tt,Cen,cinv,clabel,nc,ppri); % class: Q x S, conf: 1 x Q

disp('the confusion matrix is: ')
Cmat=Tt'*class
disp(['the classification rate is: ' num2str(100*sum(diag(Cmat))/sum(sum(Cmat))) '%']);

