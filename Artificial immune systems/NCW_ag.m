function [ dist ] = NCW_ag( C, str, y )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here



n =8;
m =4;

dist=0;

for i = 2:n+1
    for j = 2:m+1
        if strcmp(str(i-1),C{j-1}{y})
           dist=dist+1;
        end
       
    end
end


end