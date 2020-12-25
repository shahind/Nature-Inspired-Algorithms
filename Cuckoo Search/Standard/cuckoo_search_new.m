%% -----------------------------------------------------------------
%% Cuckoo Search (CS) algorithm by Xin-She Yang and Suash Deb      %
%% Programmed by Xin-She Yang at Cambridge University              %
%% Programming dates:Nov 2008 to June 2009, last revised: Dec 2009 %                         
%% Updated in 2014   (simplified version for demo only)            %
%% -----------------------------------------------------------------

% References -- Citation Details:
% (1) X.-S. Yang, S. Deb, Cuckoo search via Levy flights,
%     in: Proc. of World Congress on Nature & Biologically Inspired
%     Computing (NaBIC 2009), December 2009, India,
%     IEEE Publications, USA,  pp. 210-214 (2009).
%     http://arxiv.org/PS_cache/arxiv/pdf/1003/1003.1594v1.pdf 
% (2) X.-S. Yang, S. Deb, Engineering optimization by cuckoo search,
%     Int. J. Mathematical Modelling and Numerical Optimisation, 
%     Vol. 1, No. 4, 330-343 (2010). 
%     http://arxiv.org/PS_cache/arxiv/pdf/1005/1005.2908v2.pdf
% (3) X.-S. Yang, Nature-Inspired Optimization Algorithms, 
%     Elsevier Insights, (2014).
% ----------------------------------------------------------------%
% This demo program only implements a standard version of         %
% Cuckoo Search (CS), as the Levy flights and generation of       %
% new solutions may use slightly different methods.               %
% The pseudo code was given sequentially (select a cuckoo etc),   %
% but the implementation here uses Matlab's vector capability,    %
% which results in neater/better codes and shorter running time.  % 
% This improved implementation is different and more efficient    %
% than the demo code provided in the book by                      %
%    "Xin-She Yang, Nature-Inspired Optimization Algoirthms,      % 
%     Elsevier Insights, (2014)."                                 %
% --------------------------------------------------------------- %

% =============================================================== %
% Notes:                                                          %
% Different implementations may lead to slightly different        %
% behavour and/or results, but there is nothing wrong with it,    %
% as this is the nature of random walks and all metaheuristics.   %
% With enough number of iterations, the final results should be   %
% the same in any meaningful statistical sense.                   %
% -----------------------------------------------------------------
                     
function [bestnest,fmin]=cuckoo_search_new(inp)
if nargin<1,
   inp=[25 1000];     % Default values for n and N_IterTotal
end
n=inp(1);             % Population size
N_IterTotal=inp(2);   % Change this if you want to get better results
pa=0.25;              % Discovery rate of alien eggs/solutions
nd=15;                % Dimensions of the problem
%% Simple bounds of the search domain
Lb=-5*ones(1,nd);     % Lower bounds
Ub=5*ones(1,nd);      % Upper bounds
% Random initial solutions
for i=1:n,
nest(i,:)=Lb+(Ub-Lb).*rand(size(Lb));
end

% Get the current best of the initial population
fitness=10^10*ones(n,1);
[fmin,bestnest,nest,fitness]=get_best_nest(nest,nest,fitness);

%% Starting iterations
for iter=1:N_IterTotal,
    % Generate new solutions (but keep the current best)
     new_nest=get_cuckoos(nest,bestnest,Lb,Ub);   
     [fnew,best,nest,fitness]=get_best_nest(nest,new_nest,fitness);
    % Discovery and randomization
      new_nest=empty_nests(nest,Lb,Ub,pa) ;
    % Evaluate this set of solutions
      [fnew,best,nest,fitness]=get_best_nest(nest,new_nest,fitness);
    % Find the best objective so far  
    if fnew<fmin,
        fmin=fnew;
        bestnest=best;
    end
    % Display the results every 100 iterations
    if ~mod(iter,100),
       disp(strcat('Iteration = ',num2str(iter))); 
       % bestnest
       fmin
    end
end %% End of iterations

%% Post-optimization processing and display all the nests
disp(strcat('The best solution=',num2str(bestnest)));
disp(strcat('The best fmin=',num2str(fmin)));

%% --------------- All subfunctions are list below ------------------
%% Get cuckoos by ramdom walk
function nest=get_cuckoos(nest,best,Lb,Ub)
% Levy flights
n=size(nest,1);
% For details about Levy flights, please read Chapter 3 of the book:
% X. S. Yang, Nature-Inspired Optimization Algorithms, Elesevier, (2014).
beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);

for j=1:n,
    s=nest(j,:);
    % This is a simple way of implementing Levy flights
    % For standard random walks, use step=1;
    %% Levy flights by Mantegna's algorithm
    u=randn(size(s))*sigma;
    v=randn(size(s));
    step=u./abs(v).^(1/beta);
  
    % In the next equation, the difference factor (s-best) means that 
    % when the solution is the best solution, it remains unchanged.     
    stepsize=0.01*step.*(s-best);
    % Here the factor 0.01 comes from the fact that L/100 should be the
    % typical step size for walks/flights where L is the problem scale; 
    % otherwise, Levy flights may become too aggresive/efficient, 
    % which makes new solutions (even) jump out side of the design domain 
    % (and thus wasting evaluations).
    % Now the actual random walks or flights
    s=s+stepsize.*randn(size(s));
    % Apply simple bounds/limits
    nest(j,:)=simplebounds(s,Lb,Ub);
end

%% Find the current best solution/nest among the population
function [fmin,best,nest,fitness]=get_best_nest(nest,newnest,fitness)
% Evaluating all new solutions
for j=1:size(nest,1),
    fnew=fobj(newnest(j,:));
    if fnew<=fitness(j),
       fitness(j)=fnew;
       nest(j,:)=newnest(j,:);
    end
end
% Find the current best
[fmin,K]=min(fitness) ;
best=nest(K,:);

%% Replace some not-so-good nests by constructing new solutions/nests
function new_nest=empty_nests(nest,Lb,Ub,pa)
% A fraction of worse nests are discovered with a probability pa
n=size(nest,1);
% Discovered or not -- a status vector
K=rand(size(nest))>pa;
% Notes: In the real world, if a cuckoo's egg is very similar to 
% a host's eggs, then this cuckoo's egg is less likely to be discovered. 
% so the fitness should be related to the difference in solutions.  
% Therefore, it is a good idea to do a random walk in a biased way 
% with some random step sizes.  
%% New solution by biased/selective random walks
stepsize=rand*(nest(randperm(n),:)-nest(randperm(n),:));
new_nest=nest+stepsize.*K;
for j=1:size(new_nest,1)
    s=new_nest(j,:);
  new_nest(j,:)=simplebounds(s,Lb,Ub);  
end

% Application of simple bounds/constraints
function s=simplebounds(s,Lb,Ub)
  % Apply the lower bound
  ns_tmp=s;
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb(I);
  
  % Apply the upper bounds 
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub(J);
  % Update this new move 
  s=ns_tmp;

%% You can replace the following objective function
%% by your own functions (also update the Lb and Ub)
function z=fobj(u)
%% The D-dimensional sphere function z=sum_j=1^D (u_j-1)^2. 
%  with the minimum fmin=1 at (1,1, ...., 1); 
z=sum((u-1).^2);
