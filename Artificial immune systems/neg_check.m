function [ b ] = neg_check( C, str )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
beta=1;
threshold=0;

for i= 1:50
        b(1,i)=max(0,beta*(NCW_ag(C,str,i)-LCS_ag(C,str,i)-threshold));
end

end