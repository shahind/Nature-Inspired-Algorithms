clear all
clc
close all

d=5;                % dimension
options.lk=-32*ones(1,d);   % lower bound
options.uk=32*ones(1,d);    % upper bound
options.m=50; % Size of the population
options.MAXITER=500; % Maximum number of iterations
options.n=length(options.uk);    % dimension of the problem.
options.ObjFunction=@Ackley; % the name of the objective function
options.Display_Flag=1; % Flag for displaying results over iterations
options.run_parallel_index=0;
options.run=10;

if options.run_parallel_index
    %     run_parallel
    stream = RandStream('mrg32k3a');
    parfor index=1:options.run
        %     tic
        %     index
        set(stream,'Substream',index);
        RandStream.setGlobalStream(stream)
        [bestX, bestFitness, bestFitnessEvolution,nEval]=BH_v1(options);
        bestX_M(index,:)=bestX;
        Fbest_M(index)=bestFitness;
        fbest_evolution_M(index,:)=bestFitnessEvolution;
    end
else
    rng('default')
    for index=1:options.run
        [bestX, bestFitness, bestFitnessEvolution,nEval]=BH_v1(options);
        bestX_M(index,:)=bestX;
        Fbest_M(index)=bestFitness;
        fbest_evolution_M(index,:)=bestFitnessEvolution;
    end
end


[a,b]=min(Fbest_M);
figure
plot(1:options.MAXITER,fbest_evolution_M(b,:))
xlabel('Iterations')
ylabel('Fitness')

fprintf(' MIN=%g  MEAN=%g  MEDIAN=%g MAX=%g  SD=%g \n',...
    min(Fbest_M),mean(Fbest_M),median(Fbest_M),max(Fbest_M),std(Fbest_M))

