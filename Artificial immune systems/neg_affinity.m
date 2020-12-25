function [ b ] = neg_affinity( C )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
beta=1;
threshold=0;

b=zeros(50,50);

for i= 1:50
    for j=1:50
        b(i,j)=max(0,beta*(NCW(C,i,j)-LCS(C,i,j)-threshold));
       
    end
end

end

