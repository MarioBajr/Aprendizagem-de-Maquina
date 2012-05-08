function [ result ] = normalize( M )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here

[m, n] = size(M);
result = zeros(m, n);

for i=1:n
    t = sum(M(:, i));
    if t==0;
        t=1;
    end
    
    for j=1:m
        result(j, i) = M(j, i)/t;
    end
end

end

