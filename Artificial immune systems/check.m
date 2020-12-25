function [ precision ] = check( C, str )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


fid = fopen('antibody.txt','rt');
tmp = textscan(fid, '%s %s %s %s %s');
AP=affinity_ag(tmp,str);
AN=neg_check(tmp,str);
positive=0;
negative=0;
for i= 1:50
     if(C(i)>25)   
        positive = positive + AP(i)*C(i);
     end
end

for i= 1:50
     if(C(i)<20)   
        negative = negative - AN(i)*C(i);
     end
end

precision = positive + negative;

end