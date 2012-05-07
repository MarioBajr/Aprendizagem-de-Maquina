% bp.m - Implementation of backpropagation algorithm
% (C) copyright 2001 by Yu Hen Hu
% created: 3/17/2001
% call bpconfig.m, cvgtest.m, bpdisplay.m, bptest.m
%      rsample.m, randomize.m, actfun.m, actfunp.m
%      partunef.m

clear all, close all

irisbpconfig; % configurate the MLP network and learning parameters.

% BP iterations begins
while not_converged==1,
	% start a new epoch
   % Randomly select K training samples from the training set.
   [train,ptr,train0]=rsample(train0,K,Kr,ptr); % train is K by M+N
   z{1}=(train(:,1:M))';   % input sample matrix  M by K
   d=train(:,M+1:MN)';     % corresponding target value  N by K
   
   % Feed-forward phase, compute sum of square errors 
   for l=2:L,              % the l-th layer
      u{l}=w{l}*[ones(1,K);z{l-1}]; % u{l} is n(l) by K
      z{l}=actfun(u{l},atype(l));
   end
   error=d-z{L};           % error is N by K
   E(t)=sum(sum(error.*error));
   
   % Error back-propagation phase, compute delta error 
   delta{L}=actfunp(u{L},atype(L)).*error;  % N (=n(L)) by K
   if L>2,
      for l=L-1:-1:2,
         delta{l}=(w{l+1}(:,2:n(l)+1))'*delta{l+1}.*actfunp(u{l},atype(l));
      end
   end
   
   % update the weight matrix using gradient, momentum and random perturbation
   for l=2:L,
      dw{l}=alpha*delta{l}*[ones(1,K);z{l-1}]'+...
            mom*dw{l}+randn(size(w{l}))*0.005;
      w{l}=w{l}+dw{l};
   end

   % display the training error
   bpdisplay;

   % Test convergence to see if the convergence condition is satisfied, 
   cvgtest;
	t = t + 1;    % increment epoch count
end % while loop

disp('Final training results:')
if classreg==0,
   [Cmat,crate]=bptest(wbest,tune,atype),
elseif classreg==1,
   SS=bptestap(wbest,tune,atype),
end

if testys==1,
   disp('Apply trained MLP network to the testing data. The results are: ');
   if classreg==0,
      [Cmat,crate,cout]=bptest(wbest,test0,atype,labeled,N);
      if labeled==1, 
         disp('Confusion matrix Cmat = '); disp(Cmat);
         disp(['classification = ' num2str(crate) '%'])
      elseif labeled==0, 
      % print out classifier output only if there is no label
         disp('classifier outputs are: ')
         disp(cout);
      end
   elseif classreg==1,
      SS=bptestap(wbest,test0,atype),
   end
end

