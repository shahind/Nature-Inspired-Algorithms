function [ R , PF] = predict(L, C , str )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fid = fopen('antibody.txt','rt');
tmp = textscan(fid, '%s %s %s %s %s');

alpha=1;
threshold=1;
for i=1:50
    AP(1,i)=max(0,alpha*(LCS_pr(tmp,str,i)-threshold));
end

total = 0;

for i= 1:50
     for j= 1:50
        total = total + AP(i)*C(i)*L(i,j);
     end
end

for i= 1:50
     for j= 1:50
        PF(i,j)= AP(i)*C(i)*L(i,j)/ total ;
     end
end
display('PF is');
PF



for j= 1:50
    maximum = 0;
     for i= 1:50
        if(PF(i,j)> maximum)
        maximum = PF(i,j);
        end
     end
     R(j) = maximum;
end



end

