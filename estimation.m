function [ output_args ] = estimation( samples )
%ESTIMATION Summary of this function goes here
%   Detailed explanation goes here


[phat, pci] = mle(samples, ...
                 'distribution','binomial',...
                 'alpha',.05);

end