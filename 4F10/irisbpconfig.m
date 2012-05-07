% bpconfig.m
% configure the MLP. Called by bp.m
% mfiles used: partunef.m, scale.m
% Allow user to set up various parameters. 
% Time saving procedure: save the parameters into a file, and load the same 
%      file next time if no parameter changes are needed.
% 9/23/2001: add testing set
% 10/15/2003: allow testing set not to have labels
% (C) copyright 2001 by Yu Hen Hu
% created: 3/17/2001
% Last modification: 9/29/2001, 10/15/2003


% open a graph window to display training error vs. epoch count
figure(1),set(1,'Position',[0 400 700 300]),clf

disp('Enter:');
disp('0 - to load a previously entered configuration file mlpconfig.mat (default);');
disp('1 - to re-enter all new configurations;');
restart=input('Your choice: ');
if isempty(restart)|restart==0,
   load mlpconfig.mat
   return
end

% ==============================================================
% load data file, input network parameters
% load training and testing data samples
% it is assumed that the training file is an ascii array
% of numbers in a K by MN matrix. There are K lines, each
% corresponding to a 1xM feature vector and an 1xN target vector
% rename this file to a standard name: train0, test0
% ==============================================================

file_name='iris_tra';
eval(['load ' file_name]);   % load training file
train0=eval(file_name); eval(['clear ' file_name]);
[Kr,MN]=size(train0);
disp(['Input dimension + Output dimension = ' num2str(MN)]);
M=4;
N=MN-M;

testys=1;
file_name='iris_tes';
eval(['load ' file_name]);   % load training file
test0=eval(file_name); eval(['clear ' file_name]);
[Kt,MNt]=size(test0);
% determine if the test set has labels
if MNt == MN, labeled=1; else labeled=0; end

% ==============================================================
% scale feature vectors
%   INPUT: if input of training file is scaled, the same scaling factor will
%     be applied to scale the input of the tuning file, or other testing file
% ==============================================================
scalein=input('If want to scale input to range of -5 to 5, enter 1 (default): ');
if isempty(scalein), scalein=1; end
if scalein==1,
   if testys==1,
      [tmp,xmin,xmax]=scale([train0(:,1:M); test0(:,1:M)],-5,5); % scale input
      train0(:,1:M)=tmp(1:Kr,:); test0(:,1:M)=tmp(Kr+1:Kr+Kt,:);
   else
      [train0(:,1:M),xmin,xmax]=scale(train0(:,1:M),-5,5);    % scale input
   end
end
% output scaling will be performed after activation functions of output nodes
% have been decided.

% ==============================================================
% start configure MLP: # of layers, # hidden neurons / layer, 
% initialize weight matrices
% ==============================================================
disp('=============================================================');
L1 = input('Excluding input layer, enter total # of layers (default = 2), L = ');
if isempty(L1), L1=2; end
L=L1+1; 
disp(['The output layer has ' int2str(N) ' neurons.']);
n(1) = M;
n(L) = N; % # of output neurons = output dimension
% w is a cell array with i-th element being a weight matrix
% of the i-th layer neurons.
if L > 2, 
   for i=2:L-1,
      n(i)=input(['Number of neurons in hidden layer # ' int2str(i-1) ' = ']);
      w{i}=0.001*randn(n(i),n(i-1)+1); % first column is the bias weight
      dw{i}=zeros(size(w{i}));         % initialize dw
   end
end
w{L}=0.005*randn(n(L),n(L-1)+1); % first column is the bias weight
dw{L}=zeros(size(w{L}));

% ==============================================================
% choose types of activation function
% default: hidden layers, tanh (type = 2), output layer, sigmoid (type = 1)
% default parameter T = 1 is used.
% ==============================================================
atype=2*ones(L,1);  atype(L)=1; % default
disp('By default, hidden layers use tanh activation function, output use sigmoidal');
chostype=input('Enter 1 to change default values (default 0): ');
if isempty(chostype), chostype=0; end
if chostype==1,
   disp('=============================================================');
   disp('activation function type 1: sigmoidal');
   disp('activation function type 2: hyperbolic tangent');
   disp('activation function type 3: linear');
   for l=2:L,
      atype(l)=input(['Layer #' int2str(l) ' activation function type = ']);
   end
end

% ==============================================================
% next load a tuning set file to help determine training errors
% or partition the training file into a training and a tuning file.
% ==============================================================
disp('Enter 0 (default) if a pattern classification problem, ');
classreg=input('      1 for approximation problem: ');
if isempty(classreg), classreg=0; end

disp('=============================================================');
msg_1=[...
'To estimate training error, choose one of the following:             '
'1 - Use the entire training set to estimate training error;          '
'2 - Use a separate fixed tuning data file to estimate training error;'
'3 - Partition training set dynamically into training and tuning sets;'
'    (This is for pattern classification problem)                     '];
disp(msg_1);

chos=input('Enter your selection (default = 1): ');
if isempty(chos), chos=1; end
if chos==1,
   tune=train0;
elseif chos==2,
   dir;
   tune_name=input(' Enter tuning filename in single quote, no file extension: ');
   eval(['load ' tune_name]);
   tune=eval(tune_name);  eval(['clear ' tune_name]);
   % scale the tuning file feature vectors and output as it is newly loaded.
   if scalein==1, % scale input to [-5 5]
      [tune(:,1:M),xmin,xmax]=scale(tune(:,1:M),-5,5); 
   end

elseif chos==3, % partition the training file into a training and tuning 
   % according to a user-specified percentage
   prc=input('Percentage (0 to 100) of training data reserved for tuning: ');
   [tune,train0]=partunef(train0,M,prc); 
   [Kr,MN]=size(train0);  % this train0 is only a subset of original train0 and hence
   % Kr must be updated.
end
[Ktune,MN]=size(tune); 

% ==============================================================
% scaling the output of training set data
%     normally the output will be scaled to [outlow outhigh] = [0.2 0.8] 
%     for sigmoidal activation function, and [-0.8 0.8] for hyperbolic tangent 
%     or linear activation function at the output nodes. 
%     However, the actual output of MLP during testing of tuning file or testing
%     file will be handled differently:
%     a) Pattern classification problem: since we are concerned only with the maximum
%        among all output, the output of MLP will not be changed even it ranges only
%        between [outlow outhigh] rather than [0 1]
%     b) Approximation (regression) problem: the output of MLP will be scaled back
%        for comparison with target values
% ==============================================================

disp('=============================================================');
disp('Output from output nodes for training samples may be scaled to: ')
disp('[0.2 0.8] for sigmoidal activation function  or ');
disp('[-0.8 0.8] for hyperbolic tangent or linear activation function ');
scaleout=input('Enter 1 (default) to scale the output: ');
if isempty(scaleout), scaleout=1; end
if atype(L)==1, outlow = 0.2; elseif atype(L)==2 | atype(L) == 3, outlow = -0.8; end
outhigh=0.8; 
if scaleout==1,
   [train0(:,M+1:MN),zmin,zmax]=scale(train0(:,M+1:MN),outlow,outhigh); % scale output
   % scale the target value of tuning set 
   [tune(:,M+1:MN),zmin,zmax]=scale(tune(:,M+1:MN),outlow,outhigh); 
   % scale target value of testing set if available
   if testys==1 & labeled==1 % if testing set specifies output
      [test0(:,M+1:MN),zmin,zmax]=scale(test0(:,M+1:MN),outlow,outhigh);
   end
end

% now, we have a training file and a tuning file

% ==============================================================
% learning parameters
% ==============================================================
disp('=============================================================');
alpha=input('learning rate (between 0 and 1, default = 0.1) alpha = ');
if isempty(alpha), alpha=0.1; end
mom=input(' momentum constant (between 0 and 1, default 0.8) mom = ');
if isempty(mom), mom=0.8; end

% ==============================================================
% termination criteria
% A. Terminate when the max. # of epochs to run is reached.
% ==============================================================
nepoch=input('maximum number of epochs to run, nepoch = ');
disp(['# training samples = ' int2str(Kr)]);
K = input(['epoch size (default = ' int2str(min(64,Kr)) ', <= ' int2str(Kr) ') = ']);
if isempty(K), K=min(64,Kr); end
disp(['total # of training samples applied = ' int2str(nepoch*K)]);

% ==============================================================
% B. Check the tuning set testing result periodically. If the tuning set testing
%    results is reducing, save the weights. When the tuning set testing results
%    start increasing, stop training, and use the previously saved weights.
% ==============================================================
disp('=============================================================');
nck=input(['# of epochs between convergence check (> ' ...
      int2str(ceil(Kr/K)) '): ']);
disp(' ');
disp('If testing on tuning set meets no improvement for n0');
maxstall=input('iterations, stop training! Enter n0 = ');
nstall=0;   % initilize # of no improvement count. when nstall > maxstall, quit.
if classreg==0, 
   bstrate=0;      % initialize classification rate on tuning set to 0
elseif classreg==1,
   bstss=1;  % intialize tuning set error to maximum
   ssthresh=0.001; % initialize thres
end


% ==============================================================
% training status monitoring
% ==============================================================
E=zeros(1,nepoch);     % record training error

ndisp=5;
disp(' ');
disp(['the training error is plotted every ' int2str(ndisp) ' iterations']);
disp('Enter <Return> to use default value. ')
chos1=input('Enter a positive integer to set to a new value: ');
if isempty(chos1),
   ndisp=5;
elseif chos1>0,
   ndisp=chos1;
else
   ndisp=input('You must enter a positive integer, try again: ');
end

% ==============================================================
% intialization for the bp iterations
% ==============================================================

t = 1;  % initialize epoch counter
ptr=1;  % initialize pointer for re-sampling the training file
not_converged = 1;  % not yet converged

% ==============================================================
% save all variables into a file so that user needs not reenter all of them
% ==============================================================

save mlpconfig.mat

