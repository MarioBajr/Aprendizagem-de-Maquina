function z=MLP2(x,W1,W2,N,H,T)
% Usage: z=MLP2(x,W1,W2,N,H,T) 
% 2-layer perceptron: input x (K by M) with K samples
% output z=f(U/T) with sigmoidal activation  (K by N)
% U = W2*f(W1*x): output net matrix, (K by N)
% N: # of output units, H: # of hidden units, M # of inputs
% W1: (H by M+1): input weight matrix
% W2: (N by H+1): output weight matrix
%   neuron in the next layer
% copyright (c) 1993-2001 by Yu Hen Hu
% Last modified: 9/28/2001

[K,M]=size(x);
[h1,m1]=size(W1); % h1=H, m1=M+1
if h1~=H | m1~=M+1,
   disp(['m1 =' num2str(m1) ', h1=' num2str(h1)])
   error(' matrix W1 dim does not match input x, stop')
end
[n1,h2]=size(W2);
if n1~=N | h2~=H+1,
   error(' matrix W2 dim does not match input x, stop')
end
ax=[ones(K,1) x]*W1'; %first column of W1 is bias
y=ones(K,H)./(ones(K,H)+exp(-ax/T));
U=[ones(K,1) y]*W2'; % first column of W2 is bias
z=ones(K,N)./(ones(K,N)+exp(-U/T));
