function [bestsol,bestfitness] = ABC(prob,lb,ub,Np,T,limit)

%% Starting of ABC
f = NaN(Np,1);                      % Vector to store the objective function value of the population members
fit = NaN(Np,1);                    % Vector to store the fitness function value of the population members
trial = NaN(Np,1);                  % Initialization of the trial vector

D = length(lb);                     % Determining the number of decision variables in the problem

P = repmat(lb,Np,1) + repmat((ub-lb),Np,1).*rand(Np,D);   % Generation of the initial population

for p = 1:Np
    f(p) = prob(P(p,:));            % Evaluating the objective function value
    fit(p) = CalFit(f(p));          % Evaluating the fitness function value
end

[bestobj, ind] = min(f);            % Determine and memorize the best objective value
bestsol = P(ind,:);                 % Determine and memorize the best solution

for t = 1:T
    
    %% Employed Bee Phase
    for i = 1:Np
        [trial,P,fit,f] = GenNewSol(prob, lb, ub, Np, i, P, fit, trial, f, D);
    end
    
    %% Onlooker Bee Phase
    % as per the code of the inventors available at https://abc.erciyes.edu.tr/
    % prob=(0.9.*Fitness./max(Fitness))+0.1;
    % MATLAB Code of the ABC algorithm version 2 has been released (14.12.2009) (more optimized coding)
    
    probability = 0.9 * (fit/max(fit)) + 0.1;
    
    m = 0; n = 1;
    
    while(m < Np)
        if(rand < probability(n))
            [trial,P,fit,f] = GenNewSol(prob, lb, ub, Np, n, P, fit, trial, f, D);
            m = m + 1;
        end
        n = mod(n,Np) + 1;
    end
    
    [bestobj,ind] = min([f;bestobj]);
    CombinedSol = [P;bestsol];
    bestsol = CombinedSol(ind,:);
    
    %% Scout Bee Phase
    [val,ind] = max(trial);
    
    if (val > limit)
        trial(ind) = 0;                     % Reset the trial value to zero
        P(ind,:) = lb + (ub-lb).*rand(1,D); % Generate a random solution
        f(ind) = prob(P(ind,:));            % Determine the objective function value of the newly generated solution
        fit(ind) = CalFit(f(ind));          % Determine the fitness function value of the newly generated solution
    end
end

[bestfitness,ind] = min([f;bestobj]);
CombinedSol = [P;bestsol];
bestsol = CombinedSol(ind,:);