function [ L ] = link( L, D, AA ,n)
%LINK Summary of this function goes here
%   Detailed explanation goes here
theta=4; 
sum=0;
m=0;
for i=1:n;
    if D(i)>m
        m=D(i);
    end
end

for i=1:n;
    for j=1:n
        if(AA(i,j)>=0) && (D(i)>0.5*m || D(j)>0.5*m)
            sum=sum + D(i)*D(j)*max(0,(theta-AA(i,j)));
        end
    end
end
x=0;
for i=1:n
    for j=1:n
        
        if (i<=n/2 && i<j)    
        if (D(i)>0.5*m || D(j)>0.5*m) 
        x = (D(i)*D(j)*max(0,(theta-AA(i,j))))/ sum;
        L(i,j)=max(L(i,j),x);
        end  
        
        elseif(i>n/2 && i>j)        
        if (D(i)>0.5*m || D(j)>0.5*m) 
        x = (D(i)*D(j)*max(0,(theta-AA(i,j))))/ sum;
        L(i,j)=max(L(i,j),x);
        end      
        end     
    end
end


end

