%% Cuckoo Search (CS) algorithm by Xin-She Yang and Suash Deb     %
% Programmed by Xin-She Yang at Cambridge University              %
% Programming dates: Nov 2008 to June 2009                        %
% Last revised: Dec  2009   (simplified version for demo only)    %
% Multiobjective cuckoo search (MOCS) added in July 2012,         %
% Then, MOCS was updated in Sept 2015.                     Thanks %
% -----------------------------------------------------------------
%% References -- Citation Details:
%% 1) X.-S. Yang, S. Deb, Cuckoo search via Levy flights,
% in: Proc. of World Congress on Nature & Biologically Inspired
% Computing (NaBIC 2009), December 2009, India,
% IEEE Publications, USA,  pp. 210-214 (2009).
% http://arxiv.org/PS_cache/arxiv/pdf/1003/1003.1594v1.pdf 
%% 2) X.-S. Yang, S. Deb, Engineering optimization by cuckoo search,
% Int. J. Mathematical Modelling and Numerical Optimisation, 
% Vol. 1, No. 4, 330-343 (2010). 
% http://arxiv.org/PS_cache/arxiv/pdf/1005/1005.2908v2.pdf
%% 3) X.-S. Yang, S. Deb, Multi-objective cuckoo search for 
% Design optimization, Computers & Operations Research, 
% vol. 40, no. 6, 1616-1624 (2013).
% ----------------------------------------------------------------%
% This demo program only implements a standard version of         %
% Cuckoo Search (CS), as the Levy flights and generation of       %
% new solutions may use slightly different methods.               %
% The pseudo code was given sequentially (select a cuckoo etc),   %
% but the implementation here uses Matlab's vector capability,    %
% which results in neater/better codes and shorter running time.  % 
% This implementation is different and more efficient than the    %
% the demo code provided in the book by 
%    "Yang X. S., Nature-Inspired Optimization Algoirthms,        % 
%     Elsevier Press, 2014.  "                                    %
% --------------------------------------------------------------- %

% =============================================================== %
%% Notes:                                                         %
% 1) The constraint-handling is not included in this demo code.   %
% The main idea to show how the essential steps of cuckoo search  %
% and multi-objective cuckoo search (MOCS) can be done.           %
% 2) Different implementations may lead to slightly different     %
% behavour and/or results, but there is nothing wrong with it,    %
% as it is the nature of random walks and all metaheuristics.     %
% --------------------------------------------------------------- %
function [bestnest,fmin]=mocs_new(inp)
if nargin<1,
inp=[100 1000 0.25]; % pop_size, #iteraion, pa
end    
% Number of nests (or the population size)
n=inp(1);
% Number of iterations/generations
N_IterTotal=inp(2);
% Discovery rate of alien eggs/solutions
pa=inp(3);
d=30;   % Dimensionality of the problem
% Simple lower bounds
Lb=0*ones(1,d); 
% Simple upper bounds
Ub=1*ones(1,d);

% Number of objectives
m=2;

%% Initialize the population
for i=1:n,
   Sol(i,:)=Lb+(Ub-Lb).*rand(1,d); 
   f(i,1:m) = obj_funs(Sol(i,:), m);
end
% Store the fitness or objective values
f_new=f;
%% Sort the initialized population
x=[Sol f];  % combined into a single input
% Non-dominated sorting for the initila population
Sorted=solutions_sorting(x, m,d);
% Decompose into solutions, fitness, rank and distances
nest=Sorted(:,1:d);
f=Sorted(:,(d+1):(d+m));
RnD=Sorted(:,(d+m+1):end);

%% Starting iterations
for t=1:N_IterTotal,
    % Generate new solutions (but keep the current best)
     new_nest=get_cuckoos(nest,nest(1,:), Lb,Ub);   
  %   new_nest=nest;
     % Discovery and randomization
     new_nest=empty_nests(nest,Lb,Ub,pa) ;
     
    % Evaluate this set of solutions
      for i=1:n,
      %% Evalute the fitness/function values of the new population
        f_new(i, 1:m) = obj_funs(new_nest(i,1:d),m);
        
        if (f_new(i,1:m) <= f(i,1:m)),  
            f(i,1:m)=f_new(i,1:m);
            nest(i,:)=new_nest(i,:);
        end
        % Update the current best (stored in the first row)
        if (f_new(i,1:m) <= f(1,1:m)), 
            nest(1,1:d) = new_nest(i,1:d); 
            f(1,:)=f_new(i,:);
        end         
      end  % end of for loop
      
%% Combined population consits of both the old and new solutions
%% So the total number of solutions for sorting is 2*n
%% ! It's very important to combine both populations, otherwise,
%% the results may look odd and will be very inefficient. !
       X(1:n,:)=[new_nest f_new];      % Combine new solutions
       X((n+1):(2*n),:)=[nest f];      % Combine old solutions
       Sorted=solutions_sorting(X, m, d); 
       %% Select n solutions from a combined population of 2*n solutions
       new_Sol=Select_pop(Sorted, m, d, n);
       % Decompose the sorted solutions into solutions, fitness & ranking
       nest=new_Sol(:,1:d);           % Sorted solutions/variables
       f=new_Sol(:,(d+1):(d+m));      % Sorted objective values
       RnD=new_Sol(:,(d+m+1):end);    % Sorted ranks and distances
       
  %% Running display at each 100 iterations
   if ~mod(t,100), 
     disp(strcat('Iterations t=',num2str(t))); 
     plot(f(:, 1), f(:, 2),'rs','MarkerSize',3); 
     axis([0 1 -0.8 1]);
     xlabel('f_1'); ylabel('f_2');
     drawnow;
   end   

end %% End of iterations


%% --------------- All subfunctions are list below ------------------     %
%% Get cuckoos by ramdom walk
function nest=get_cuckoos(nest,best,Lb,Ub)
n=size(nest,1);
% For details, please see the chapters of the following Elsevier book:  
% X. S. Yang, Nature-Inspired Optimization Algorithms, Elsevier, (2014).
beta=3/2;  % Levy exponent in Levy flights
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);

for j=1:n,
    s=nest(j,:);
    %% Levy flights by Mantegna's algorithm
    u=randn(size(s))*sigma;
    v=randn(size(s));
    step=u./abs(v).^(1/beta);
    stepsize=0.1*step.*(s-best);
    % Now the actual random walks or flights
    s=s+stepsize.*randn(size(s));
   % Apply simple bounds/limits
   nest(j,:)=simplebounds(s,Lb,Ub);
end

%% Replace some nests by constructing new solutions/nests
function new_nest=empty_nests(nest,Lb,Ub,pa)
% A fraction of worse nests are discovered with a probability pa
[n,d]=size(nest);
% The solutions represented by cuckoos to be discovered or not 
% with a probability pa. This action is implemented as a status vector
K=rand(size(nest))>pa; 
%% New solution by biased/selective random walks
stepsize=rand(1,d).*(nest(randperm(n),:)-nest(randperm(n),:));
new_nest=nest+stepsize.*K;
for j=1:size(new_nest,1)
    s=new_nest(j,:);
    new_nest(j,:)=simplebounds(s,Lb,Ub);  
end

% Application of simple bounds
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Objective functions 
function f = obj_funs(x, m)
% Zitzler-Deb-Thiele's funciton No 3 (ZDT function 3)
% M = # of objectives
% d = # of variables/dimensions
d=length(x);  % d=30 for ZDT 3
% First objective f1
f(1) = x(1);
g=1+9/29*sum(x(2:d));
h=1-sqrt(f(1)/g)-f(1)/g*sin(10*pi*f(1));
% Second objective f2
f(2) = g*h;
%%%%%%%%%%%%%%%%%% end of the definitions of obojectives %%%%%%%%%%%%%%%%%%

function new_Sol = Select_pop(nest, m, ndim, npop)
% The input population to this part has twice (ntwice) of the needed 
% population size (npop). Thus, selection is done based on ranking and 
% crowding distances, calculated from the non-dominated sorting
ntwice= size(nest,1);
% Ranking is stored in column Krank
Krank=m+ndim+1;
% Sort the population of size 2*npop according to their ranks
[~,Index] = sort(nest(:,Krank)); sorted_nest=nest(Index,:);
% Get the maximum rank among the population
RankMax=max(nest(:,Krank)); 

%% Main loop for selecting solutions based on ranks and crowding distances
K = 0;  % Initialization for the rank counter 
% Loop over all ranks in the population
for i =1:RankMax,  
    % Obtain the current rank i from sorted solutions
    RankSol = max(find(sorted_nest(:, Krank) == i));
    % In the new cuckoos/solutions, there can be npop solutions to fill
    if RankSol<npop,
       new_Sol(K+1:RankSol,:)=sorted_nest(K+1:RankSol,:);
    end 
    % If the population after addition is large than npop, re-arrangement
    % or selection is carried out
    if RankSol>=npop
        % Sort/Select the solutions with the current rank 
        candidate_nest = sorted_nest(K + 1 : RankSol, :);
        [~,tmp_Rank]=sort(candidate_nest(:,Krank+1),'descend');
        % Fill the rest (npop-K) cuckoo/solutions up to npop solutions 
        for j = 1:(npop-K), 
            new_Sol(K+j,:)=candidate_nest(tmp_Rank(j),:);
        end
    end
    % Record and update the current rank after adding new cuckoo solutions
    K = RankSol;
end

