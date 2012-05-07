function [d,member,distance]=kmeantest(X,W)
% Usage: [d,member,distance]=kmeantest(X,W)
% clustering membership determination
% Input -  W: initial weight vectors  c by N matrix, c: # of clusters
%       -  X: K by N input vectors to be clustered
% Output - d: average distortion sum of square error
%          member: membership of each X:  K by 1 vector of elements 1 to c
%          dist: exact distortion between each feature vector and cluster center
%                a c x K matrix
% assume L2 norm distortion measure 
% call mfile: dist.m
%
% copyright (c) 1997  by Yu Hen Hu 
% created:  11/8/97
% modified: 3/11/2000 change name from kmeanerr.m to kmeantest.m
% modified: 4/2/2001 add new output distance
% last modified: 9/24/2001

[c,N]=size(W);
[K,N]=size(X);

% step A. evaluation of distortion using L2 norm

distance=dist(X,W);             % K by c matrix 
[tmp1,ind]=sort(distance');     % first row of ind gives new cluster assignment 
                                % of each data vector
d=sqrt(sum(tmp1(1,:).*tmp1(1,:)));
member=ind(1,:)';
   
