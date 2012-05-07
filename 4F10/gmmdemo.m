

% mldemo.m - clustering algorithm demonstration program
% mfiles used: datagen.m, mlgmm.m
% (C) copyright 2001-2005 by Yu Hen Hu
% created: 9/26/2001
% modified: 9/29/2005

clear all, clf
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

[Cen,cinv,clabel,nc,ppri]=mltrainnew(Pr,Tr);

[class,conf,Cmat]=mltestnew(Pr,Tr,Cen,cinv,clabel,nc,ppri);
disp('the training confusion matrix is: ')
Cmat
disp(['the classification rate is: ' num2str(100*sum(diag(Cmat))/sum(sum(Cmat))) '%']);

[class,conf,Cmat]=mltestnew(Pt,Tt,Cen,cinv,clabel,nc,ppri);
disp('the test confusion matrix is: ')
Cmat
disp(['the classification rate is: ' num2str(100*sum(diag(Cmat))/sum(sum(Cmat))) '%']);

