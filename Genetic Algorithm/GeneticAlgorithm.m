function [bestsol,bestfitness] = GeneticAlgorithm(prob,lb,ub,Np,T,etac,etam,Pc,Pm)

f = NaN(Np,1);                      % Vector to store the fitness function value of the population members

OffspringObj = NaN(Np,1);           % Vector to store the fitness function value of the offspring members

D = length(lb);                     % Determining the number of decision variables in the problem

P = repmat(lb,Np,1) + repmat((ub-lb),Np,1).*rand(Np,D);   % Generation of the initial population

for p = 1:Np
    f(p) = prob(P(p,:));            % Evaluating the fitness function of the initial population
end

%% Iteration loop
for t = 1: T
    
    %% Tournament selection 
    MatingPool = TournamentSelection(f,Np);          % Performing the tournaments to select the mating pool
    Parent = P(MatingPool,:);                        % Selecting parent solution 
    
    %% Crossover
    offspring  = CrossoverSBX(Parent,Pc,etac,lb,ub);
    
    %% Mutation
    offspring  = MutationPoly(offspring,Pm,etam,lb,ub);
    
    for j = 1:Np
        OffspringObj(j) = prob(offspring(j,:));     % Evaluating the fitness of the offspring solution
    end
        
    CombinedPopulation = [P; offspring];           
    [f,ind] = sort([f;OffspringObj]);               % mu + lambda selection
    
    f = f(1:Np);
    P = CombinedPopulation(ind(1:Np),:);    
    
end

bestfitness = f(1)
bestsol = P(1,:)