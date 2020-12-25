function [ a ] = affinity_aa(C)
%AFFINITY_AA Summary of this function goes here
%   Detailed explanation goes here
alpha=1;
threshold=1;
a=zeros(50,50);

for i= 1:50
    for j=1:50
        a(i,j)=max(0,alpha*(LCS(C,i,j)-threshold));
      
    end
end


end

