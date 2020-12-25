function [ D ] = LCS_ag( C,str,y )
%TEST Summary of this function goes here
%   Detailed explanation goes here

a = C;
b = str;

la = 8;
lb = 4;

mat = zeros(la+1, lb+1); %add a zero row and colum

% create a mat
for ii=1:la
    for jj=1:lb
        if strcmp(str(ii),C{jj}{y})
            mat(ii+1,jj+1)=1;
        end
    end
end

for ii=2:size(mat,1)
    for jj=2:size(mat,2)
        if mat(ii,jj)==1 %same last letter
            mat(ii,jj) = 1 + mat(ii-1,jj-1);
        else %different last letter
            mat(ii,jj) = max(mat(ii-1,jj), mat(ii,jj-1));
        end
    end
end
D= mat(end,end);
end
