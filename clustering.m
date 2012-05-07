function clustering( samples, qtdClass1, qtdClass2 )

% K-Means
opts = statset('Display','final');
[idx,ctrs] = kmeans(samples,2,...
                    'Replicates',100);

% Labels
cls = [ones(qtdClass1, 1); repmat(2, [qtdClass2 1])];

% Plot
hold all
plot(samples(idx==1 & cls==1,1),samples(idx==1 & cls==1,2),'ro','MarkerSize',5);% Correct class 1 => cluster 1
plot(samples(idx==2 & cls==1,1),samples(idx==2 & cls==1,2),'bo','MarkerSize',5);% Wrong   class 1 => cluster 2
plot(samples(idx==2 & cls==2,1),samples(idx==2 & cls==2,2),'b+','MarkerSize',5);% Correct class 2 => cluster 2
plot(samples(idx==1 & cls==2,1),samples(idx==1 & cls==2,2),'r+','MarkerSize',5);% Wrong   class 2 => cluster 1
plot(ctrs(:,1),ctrs(:,2),'ks', ...
    'MarkerSize',7,'LineWidth',1, 'MarkerFaceColor',[.49 1 .63]);

cls1V = size(samples(idx==1 & cls==1,1), 1);
cls1F = size(samples(idx==2 & cls==1,1), 1);
cls2V = size(samples(idx==2 & cls==2,1), 1);
cls2F = size(samples(idx==1 & cls==2,1), 1);

if ((cls1F+cls2F)/(qtdClass1+qtdClass2)) > .5
    cls1V = size(samples(idx==2 & cls==1,1), 1);
    cls1F = size(samples(idx==1 & cls==1,1), 1);
    cls2V = size(samples(idx==1 & cls==2,1), 1);
    cls2F = size(samples(idx==2 & cls==2,1), 1);
end

clas1 = qtdClass1;
clas2 = qtdClass2;
clasV = (cls1V+cls2V);
clasF = (cls1F+cls2F);
all = (clasV+clasF);

contingency = [cls1V cls2F; cls1F cls2V];
sumA = sum(contingency')';
sumB = sum(contingency)';

index = 0;
for i=1:2
    for j=1:2
%         fprintf('Index %d %d => %d\n', i, j, contingency(i, j));
        if contingency(i, j) >= 2
            index = index + nchoosek(contingency(i, j),2);
        end
    end
end

n2 = nchoosek(all, 2);
expectedIndexA = 0;
expectedIndexB = 0;

for i=1:2
    expectedIndexA = expectedIndexA + nchoosek(sumA(i, 1),2);
    expectedIndexB = expectedIndexB + nchoosek(sumB(i, 1),2);
end

expectedIndex = (expectedIndexA*expectedIndexB)/n2;
maxIndex = (expectedIndexA+expectedIndexB)/2;

adjustedIndex = (index-expectedIndex)/(maxIndex-expectedIndex);

fprintf('Indice de Rand Corrigido: %.4f\n', adjustedIndex);
fprintf('Error Classificacao Global: %.4f\n', (clasF/all));
fprintf('Error Classificacao Classe 1: %.4f\n', (cls1F/clas1));
fprintf('Error Classificacao Classe 2: %.4f\n', (cls2F/clas2));

end