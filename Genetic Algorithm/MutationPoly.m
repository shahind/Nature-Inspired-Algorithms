function offspring  = MutationPoly(offspring,Pm,etam,lb,ub)

[Np,D] = size(offspring); 

for i = 1:Np
    r = rand;
    if r < Pm         % Checking for mutation probability
        for j = 1:D
            r = rand;                                                       % Generating random number to determine the delta value
            if r<0.5
                delta = (2*r)^(1/(etam+1)) - 1;                             % Calculating delta value 
            else
                delta = 1 - (2*(1-r))^(1/(etam+1));                     % Calculating delta value
            end
            offspring(i,j)  =  offspring(i,j)+ (ub(j)-lb(j))*delta;         % Mutating each variable of offspring solution
        end
        offspring(i,:) = max(offspring(i,:),lb);     % Bounding the violating variables to their lower bound
        offspring(i,:) = min(offspring(i,:),ub);     % Bounding the violating variables to their upper bound
    end
end