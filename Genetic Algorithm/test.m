clc                                 % To clear the command window
clear                               % To clear the workspace

%% Problem settings
lb = [0 0 0 0 0];                   % Lower bound
ub = [10 10 10 10 10];              % Upper bound
prob = @SphereNew;                  % Fitness function


%% Parameters for Genetic Algorithm
Np = 6;                            % Population Size
T = 10;                            % No. of iterations
etac = 20;                         % Distribution index for crossover
etam = 20;                         % Distribution index for mutation
Pc = 0.8;                          % Crossover probability
Pm = 0.2;                          % Mutation probability


rng(1,'twister')

[bestsol,bestfitness] = GeneticAlgorithm(prob,lb,ub,Np,T,etac,etam,Pc,Pm);