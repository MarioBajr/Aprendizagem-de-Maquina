function [ globalScore,  classScore] = evaluatingClassifiers( samples, labels )

Nfold        = 10;
[~, Nf]   = size(samples);
hNf          = Nf/2;

part         = 1:hNf;
Fin1         = part(randperm(hNf));
Fin1         = reshape(Fin1, hNf/Nfold, [])';
part         = hNf+1:Nf;
Fin2         = part(randperm(hNf));
Fin2         = reshape(part, hNf/Nfold, [])';

Fin          = horzcat(Fin1, Fin2);

train_idx= zeros(Nfold,Nf/Nfold*(Nfold-1));
test_idx = zeros(Nfold,Nf/Nfold);
for i=1:Nfold,
    train_idx(i,:) = reshape(Fin([1:i-1,i+1:Nfold],:),1,Nf*(Nfold-1)/Nfold);    
    test_idx(i,:)  = Fin(i,:);
end

%First, get Nfold cross validation of error 
globalScore = zeros(Nfold, 4);
classScore = zeros(Nfold, 8);

C = zeros(20, 30);

for i = 1:Nfold,
    
    testLabels = labels(test_idx(i,:));
    
    %ML + EM
    resultLabels  = estimation(samples(:,train_idx(i,:)), labels(train_idx(i,:)), samples(:,test_idx(i,:)));
    [globalError, classErrors] = classifierError(testLabels, resultLabels);
    globalScore(i, 1) = globalError;
    classScore(i, 1:2) = classErrors;
    
    %Parzen
    hn = 0.4;
    resultLabels  = Parzen(samples(:,train_idx(i,:)), labels(train_idx(i,:)), samples(:,test_idx(i,:)), hn);
    [globalError, classErrors] = classifierError(testLabels, resultLabels);
    globalScore(i, 2) = globalError;
    classScore(i, 3:4) = classErrors;
    
    %knn
    k = 3;
    resultLabels  = Nearest_Neighbor(samples(:,train_idx(i,:)), labels(train_idx(i,:)), samples(:,test_idx(i,:)), k);
    [globalError, classErrors] = classifierError(testLabels, resultLabels);
    globalScore(i, 3) = globalError;
    classScore(i, 5:6) = classErrors;
    
    %sum
    [resultLabels, V] = sumClassifierTest(samples(:,train_idx(i,:)), labels(train_idx(i,:)), samples(:,test_idx(i,:)), k, hn);
    [globalError, classErrors] = classifierError(testLabels, resultLabels);
    globalScore(i, 4) = globalError;
    classScore(i, 7:8) = classErrors;
    
    if sum(globalScore(i, 1:3)) < globalError
        disp('Teste!');
        break;
    end
end

end