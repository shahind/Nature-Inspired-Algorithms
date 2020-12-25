%Longest common subsequence problem
%Algorito.com 2009

clear; clc;
a = 'aabbab';
b = 'bbaa';

la = length(a);
lb = length(b);

mat = zeros(la+1, lb+1); %add a zero row and colum

% create a mat
for ii=1:la
    for jj=1:lb
        if a(ii)==b(jj)
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


%% output
fprintf('\nLength of Longest Common Subsequence = %d\n',mat(end,end));
