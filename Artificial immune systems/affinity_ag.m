function [ ag ] = affinity_ag( C, str )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
alpha=1;
threshold=1;
for i=1:50
    ag(1,i)=max(0,alpha*(LCS_ag(C,str,i)-threshold));
end

end

