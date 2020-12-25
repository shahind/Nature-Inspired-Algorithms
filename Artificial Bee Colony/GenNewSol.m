function [trial,P,fit,f] = GenNewSol(prob, lb, ub, Np, n, P, fit, trial, f, D)

j = randi(D,1);                 % Randomly select the variable that is to be changed
p = randi(Np,1);                % Randomly select the neighbour

while (p == n)                  % Ensuring that the neighbour is different from the current solution
    p = randi(Np,1);
end

Xnew = P(n,:);                  % Variable to generate a new solution

Phi = -1 + (1-(-1))*rand;       % Generating a random number between -1 and 1

Xnew(j) = P(n,j) + Phi*(P(n,j) - P(p,j));  % Generating a new solution
Xnew(j) = min(Xnew(j),ub(j));    % Bounding the violating variables to their upper bound
Xnew(j) = max(Xnew(j),lb(j));    % Bounding the violating variables to their lower bound

ObjNewSol = prob(Xnew);             % Determining the objective function value
FitnessNewSol = CalFit(ObjNewSol);  % Determining the fitness function value

if (FitnessNewSol > fit(n)) 
    P(n,:) = Xnew;               % New solution enters the pool of solutions
    fit(n) = FitnessNewSol;      % Update the fitness value
    f(n) = ObjNewSol;            % Update the objective function value
    trial(n) = 0;                % Resetting trial to zero
else
    trial(n) = trial(n)+1;       % Increase the value of the trial counter
end