function p=update(p,low,up)
[popsize,dim]=size(p);
for i=1:popsize
    for j=1:dim
        if p(i,j)<low(j),
            p(i,j)=rand*(up(j)-low(j))+low(j);
        end
        if p(i,j)>up(j),
            p(i,j)=rand*(up(j)-low(j))+low(j);
        end
    end
end