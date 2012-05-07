% mldemo.m - clustering algorithm demonstration program
% mfiles used: datagen.m, mlgmm.m
% (C) copyright 2001-2005 by Yu Hen Hu
% created: 9/26/2001
% modified: 9/29/2005

clear all, clf
disp('Enter 1 (default) to use synthesized data set;')
disp('Enter 2 to use Iris data set.')
chos=input('Enter your choice of data sets: ');
if isempty(chos), chos=1; end
if chos==1.
    echo on
   % We will generate data using a utility function datagen.m
   % there will be two classes of data. The data are generated from three
   % Nvec: (1xclass) # data in each of the c gaussian distr.
   % mean_var: Each column is a cluster
   %   row #1 and #2: coordinates of cluster centers
   %   row #3:        variance of both dimension, or dimension #1 if there is 4-th row
   %   row #4:        variance of another dimension
   %   row #5:        rotation angle is in [0  90] degrees
   Nvec=[100 100 100];
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
   figure(1),plot(Pr(find(Tr(:,1)==1),1),Pr(find(Tr(:,1)==1),2),'.g',...
      Pr(find(Tr(:,2)==1),1),Pr(find(Tr(:,2)==1),2),'.b',Wtrue(:,1),Wtrue(:,2),'or')
   legend('class 1','class 2','center of Gaussion distribution')
   clear fr ft
   % the generated data is shown in Figure 1.
elseif chos==2,
   load iris_tra; load iris_tes; % load training and testing file
   % feature dimension = 4, target dimension = 3
   Pr=iris_tra(:,1:4); Tr=iris_tra(:,5:7);
   Pt=iris_tes(:,1:4); Tt=iris_tes(:,5:7);
   disp('using Iris data set, feature dimension = 4, 3 classes');
   idx1=find(Tr(:,1)); idx2=find(Tr(:,2)); idx3=find(Tr(:,3));
   figure(1),clf
   subplot(121),plot(Pr(idx1,1),Pr(idx1,2),'og',Pr(idx2,1),Pr(idx2,2),'.b',...
       Pr(idx3,1),Pr(idx3,2),'.r');xlabel('figure 2'),ylabel('figure 1')
   subplot(122),plot(Pr(idx1,3),Pr(idx1,4),'og',Pr(idx2,3),Pr(idx2,4),'.b',...
       Pr(idx3,3),Pr(idx3,4),'.r');xlabel('figure 4'),ylabel('figure 3')
   clear iris_tra iris_tes
end
% press a key to continue
pause

mode = 0;  % use uni-modal Gaussian
% that is: one Gaussion model per class
% mode = 1 will allow you to interactively choose Gaussian mixture model.
% [Cen,cinv,clabel,nc,ppri]=mltrainnew(Pr,Tr,mode);
[Cen,cinv,clabel,nc,ppri]=mltrainnew(Pr,Tr);
[class,conf,Cmat]=mltestnew(Pt,Tt,Cen,cinv,clabel,nc,ppri);

disp('the confusion matrix is: ')
Cmat
disp(['the classification rate is: ' num2str(100*sum(diag(Cmat))/sum(sum(Cmat))) '%']);

