function offspring  = CrossoverSBX(Parent,Pc,etac,lb,ub)

[Np,D] = size(Parent);                      % Detemining the no. of population and decision variables
indx = randperm(Np);                        % Permutating numbers from 1 to Np
Parent = Parent(indx,:);                    % Randomly shuffling parent solutions
offspring = NaN(Np,D);                      % Matrix to store offspring solutions

for i = 1:2:Np                              % Selecting parents in pairs for crossover
    
    r = rand;                               % Generating random number to decide if crossover is to be performed
 
    if r < Pc                               % Checking for crossover probability
        
        for j = 1:D
            
            r = rand;                       % Generating random number to determine the Beta value
            
            if r <= 0.5
                beta = (2*r)^(1/(etac+1));           % Calculating beta value
            else
                beta = (1/(2*(1 - r)))^(1/(etac+1)); % Calculating beta value
            end
            
            offspring(i,j)   = 0.5*(((1 + beta)*Parent(i,j)) + (1 - beta)*Parent(i+1,j));   % Generating each variable of first offspring
            offspring(i+1,j) = 0.5*(((1 - beta)*Parent(i,j)) + (1 + beta)*Parent(i+1,j));   % Generating each variable of second offspring
        end
        
        offspring(i,:) = max(offspring(i,:),lb);                    % Bounding the violating variables to their lower bound
        offspring(i+1,:) = min(offspring(i+1,:),ub);                % Bounding the violating variables to their upper bound
        
    else
        
        offspring(i,:) =  Parent(i,:);               % Copying the first parent solution as first offspring in the absence of crossover
        offspring(i+1,:) =  Parent(i+1,:);           % Copying the second parent solution as offspring in the absence of crossover
    end
end
