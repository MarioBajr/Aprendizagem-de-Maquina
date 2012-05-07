% cvgtest.m - convergence test. 
% A subroutine called specifically by bp.m
% mfile used: bptest.m, partunef.m, scale.m 
% (C) copyright 2001 by Yu Hen Hu
% created: 3/19/2001
% modified: 10/16/2001: add line 26 bstrate=crate;

% ==============================================================
% termination criteria
% A. Terminate when the max. # of epochs to run is reached.
% ==============================================================
if t>=nepoch;
   not_converged=0;
   disp('Terminate training since Max # of epochs has been reached');
end
% ==============================================================
% B. Check the tuning set testing result periodically. If the tuning set testing
%    results is reducing, save the weights. When the tuning set testing results
%    start increasing, stop training, and use the previously saved weights.
% ==============================================================
if rem(t,nck)==0, % time to check tuning set testing result
   disp(['Epoch # ' int2str(t)])
   if classreg==0, % if pattern classification problem
      [Cmat,crate]=bptest(w,tune,atype),
      if crate > bstrate, % if the classification of tuning set is improving
         bstrate=crate;
         wbest=w; % memorize the best weights
         nstall=0; % reset the no-improvement count
      else
         nstall=nstall+1; % if no improvement, increment the no-improvement count
      end % if crate
   elseif classreg==1, % for regression problems
      SS=bptestap(w,tune,atype) % sum of square error/(# samples*# output)
      if SS < bstss,
         bstss=SS;
         wbest=w;
         nstall=0;     % reset stall count
      else
         nstall=nstall+1;
      end % if SS
   end % if classreg
   
   if nstall>maxstall, % continuous maxstall no improvement, terminate
      not_converged=0;
      disp(['Terminate because no improvement for ' int2str(nstall) ' consecutive checks']);
   end % if nstall
   
   % for pattern classificaiton problem, if 
   % tuning set classification rate = 100%, terminate
   if classreg==0 & crate == 100,
      not_converged=0;
      disp('Terminate because classification rate of tuning set is 100%')
   % for approximation problem, if tuning set error < ssthresh, terminate
   elseif classreg==1 & SS < ssthresh,
      not_converged=0;
      disp(['Terminate as approx. error of tuning set < ' num2str(ssthresh)]);
   end
   
   if chos == 3, % repartition the training and tuning set
      [tune,train0]=partunef([train0;tune],M,prc);
      [Kr,MN]=size(train0);  % this train0 is only a subset of original train0 
   end
end