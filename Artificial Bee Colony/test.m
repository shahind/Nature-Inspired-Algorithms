clc
clear
close all

%% Problem settings
lb = [-100 -100 -100 -100];         % Lower bound
ub = [100 100 100  100];            % Upper bound
prob = @Griewank;                 % Fitness function

%% Algorithm parameters
Np = 10;                            % Population Size
T = 50;                             % No. of iterations
limit = 3;                          % Parameter limit indicating maximum number of failures

rng(2,'twister')

[bestsol,bestfitness] = ABC(prob,lb,ub,Np,T,limit)



