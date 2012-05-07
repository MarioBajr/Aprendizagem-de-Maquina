function drawSamples( samples, labels, cLabels, centers )
%DRAWSAMPLES Summary of this function goes here
%   Detailed explanation goes here

figure
hold all
plot(samples(cLabels==1 & labels==1,1),samples(cLabels==1 & labels==1,2),'ro','MarkerSize',5);% Correct class 1 => cluster 1
plot(samples(cLabels==2 & labels==1,1),samples(cLabels==2 & labels==1,2),'bo','MarkerSize',5);% Wrong   class 1 => cluster 2
plot(samples(cLabels==2 & labels==2,1),samples(cLabels==2 & labels==2,2),'b+','MarkerSize',5);% Correct class 2 => cluster 2
plot(samples(cLabels==1 & labels==2,1),samples(cLabels==1 & labels==2,2),'r+','MarkerSize',5);% Wrong   class 2 => cluster 1

if ~isempty(centers)
    plot(centers(:,1),centers(:,2),'ks', ...
        'MarkerSize',7,'LineWidth',1, 'MarkerFaceColor',[.49 1 .63]);
end

end

