function [ D ] = Farmer( C, AA, NA, AN )
%FARMER Summary of this function goes here
%   Detailed explanation goes here
eta=0.001;
gamma=.01;
D=[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10];


 for j=1:50
        for i=1:50
            if i==j
                D(j)=D(j)+0;
            else
            D(j)=D(j)+gamma*(AA(i,j)*C(i)*C(j)-NA(i,j)*C(i)*C(j));
            end
        end
        D(j)=D(j)+AN(j)*C(j)*50;
        D(j)=D(j)*eta;
 end
max=0;    
for i=1:50
    if D(i)> max
        max=D(i);
    end
end

for i=1:50
    if abs(D(i))<0.3*max
        D(i)=0;
    end
end
 
end

