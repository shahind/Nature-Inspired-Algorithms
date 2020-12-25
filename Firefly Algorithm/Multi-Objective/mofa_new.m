%% This demo shows how the multiobjective firefly algorithm (MOFA) works  %
%% The standard firefly algorithm (FA) was developed by Xin-She Yang and  %
%% its Matlab code is alrealy available online at Mathworks, etc.         %
%% This demo focuses on the MOFA with non-dominated sorting               %
%% ---------------------------------------------------------------------- % 

%% Programmed by Xin-She Yang in 2011 and 2012 @ Cambridge Univ and 
%% National Physics Laboratory, London. Updated and last modified 
%% by X S Yang in 2014, and then 2015. 
% References:
% (1) Xin-She Yang, Firefly algorithm, stochastic test functions and 
%     design optimizaiton, Int. Journal of Bio-Inspired Computation, 
%     vol. 2, no. 2, 78-84 (2010). 
% (2) Xin-She Yang, Multiobjective firely algorithm for continuous
%     optimizatoin, Engineering with Computers, vol. 29, no. 2, 
%     175--184 (2013).
% (3) Xin-She Yang, Nature-Inspired Optimization Algorithms, 
%     Elsevier Insight, (2014).  [Book]
% -----------------------------------------------------------------------

function mofa_new(inp)  
if nargin<1,    
  inp=[100 1000]; % Default parameters
end
n=inp(1);               % Population size (number of fireflies)
tMax=inp(2);            % Maximum number of iterations
alpha=1.0;              % Randomness strength 0--1 (highly random)
beta0=1.0;              % Attractiveness constant
gamma=0.1;              % Absorption coefficient
theta=10^(-4/tMax);     % The parameter theta can be taken as 0.97 to 0.99    
                        % This is a randomness reduction factor for alpha

% For the ZDT Function #3 with m=2 objectives
m=2;             % Number of objectives
RnD=zeros(n,2);  % Initilize the rank and distance matrix
% Dimension of the search/independent variables
d=30;
Lb=0*ones(1,d);   % Lower bounds/limits
Ub=1*ones(1,d);   % Upper bounds/limits
% Generating the initial locations of n fireflies
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
Sol=Sorted(:,1:d);  S_new=Sol;       % Record solutions 
f=Sorted(:,(d+1):(d+m));  f_new=f;   % Record objectives
RnD=Sorted(:,(d+m+1):end);           % Record ranks
   
for t=1:tMax,          %%%%% start the firely algorithm iterations %%%%%
   alpha=alpha*theta;  % Reduce alpha by a factor 0<theta<1
   scale=abs(Ub-Lb);   % Scale of the optimization problem
   Sol_old=Sol;        % Save the old population
   f_old=f;            % Save the old population objectives
% Two loops over all the n fireflies
for i=1:n,
    for j=i:n, 
      % Update moves and move to the brighter/more attractive
      % That is, all m objectives [i.e., f(,1:m)] should improve. 
      % For example, for m=2, this means that the logical 
      % condition (f(j,1)<=f(i,1) & f(j,2) <=f(i,2)) is true.     
      if (f(j,1:m)<=f(i,1:m)),     
         r=sqrt(sum((Sol(i,:)-Sol(j,:)).^2));
         beta=beta0*exp(-gamma*r.^2);     % Attractiveness
         steps=alpha.*(rand(1,d)-0.5).*scale;
      % The FA equation for updating position vectors 
      % That is, to move firefly i torwards firefly j
         Sol(i,:)=Sol(i,:)+beta*(Sol(j,:)-Sol(i,:))+steps;
         Sol(i,:)=simplebounds(Sol(i,:),Lb,Ub);
      end
         f(i,1:m)=obj_funs(Sol(i,1:d),m);   
   end % end for j
end % end for i
   
   %% Evalute the fitness/function values of the new population
   for j=1:n,
        f_new(j, 1:m)=obj_funs(Sol(j,1:d),m);
        if (f_new(j,1:m) <= f(j,1:m)),   % if all improve
            f(j,1:m)=f_new(j,1:m);
        end
        % Update the current best (stored in the first row)
        if (f_new(j,1:m) <= f(1,1:m)), 
            Sol(1,1:d) = Sol(j,1:d); 
            f_new(1,:)=f_new(j,:);
        end
     end % end of for loop j
     
%% ! It's very important to combine both populations, otherwise,
%% the results may look odd and will be very inefficient. !     
%% The combined population consits of both the old and new solutions
%% So the total size of the combined population for sorting is 2*n
       X(1:n,:)=[Sol f_new];               % Combine new solutions
       X((n+1):(2*n),:)=[Sol_old f_old];   % Combine old solutions
       Sorted=solutions_sorting(X, m, d);
       %% Select n solutions among a combined population of 2*n solutions
       new_Sol=Select_pop(Sorted, m, d, n);
       % Decompose into solutions, fitness and ranking
       Sol=new_Sol(:,1:d);             % Sorted solutions
       f=new_Sol(:,(d+1):(d+m));       % Sorted objective values
       RnD=new_Sol(:,(d+m+1):end);     % Sorted ranks and distances
    
  %% Running display at each 100 iterations
   if ~mod(t,100), 
     disp(strcat('Iterations t=',num2str(t))); 
     plot(f(:, 1), f(:, 2),'ro','MarkerSize',3); 
     axis([0 1 -0.8 1]);
     xlabel('f_1'); ylabel('f_2');
     drawnow;
   end        

end % End of t loop (up to tMax) and end of the main FA loop  

%% Make sure that new fireflies are within the bounds/limits
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
% Objective functions
function f = obj_funs(x, m)
% Zitzler-Deb-Thiele's funciton No 3 (ZDT function 3)
% m = # of objectives   % d = # of variables/dimensions
d=length(x);  % d=30 for ZDT 3
% First objective f1
f(1) = x(1);
g=1+9/29*sum(x(2:d));
h=1-sqrt(f(1)/g)-f(1)/g*sin(10*pi*f(1));
% Second objective f2
f(2) = g*h;

%%%%%%%%%%%%%%%%%% end of the definitions of obojectives %%%%%%%%%%%%%%%%%%

function new_Sol = Select_pop(firefly, m, ndim, npop)
% The input population to this part has twice (ntwice) of the needed 
% population size (npop). Thus, selection is done based on ranking and 
% crowding distances, calculated from the non-dominated sorting
ntwice= size(firefly,1);
% Ranking is stored in column Krank
Krank=m+ndim+1;
% Sort the population of size 2*npop according to their ranks
[~,Index] = sort(firefly(:,Krank)); 
sorted_firefly=firefly(Index,:);
% Get the maximum rank among the population
RankMax=max(firefly(:,Krank)); 

%% Main loop for selecting solutions based on ranks and crowding distances
K = 0;  % Initialization for the rank counter 
% Loop over all ranks in the population
for i =1:RankMax,  
    % Obtain the current rank i from sorted solutions
    RankSol = max(find(sorted_firefly(:, Krank) == i));
    % In the new solutions, there can be npop solutions to fill
    if RankSol<npop,
       new_Sol(K+1:RankSol,:)=sorted_firefly(K+1:RankSol,:);
    end 
    % If the population after addition is large than npop, re-arrangement
    % or selection is carried out
    if RankSol>=npop
        % Sort/Select the solutions with the current rank 
        candidate_firefly=sorted_firefly(K + 1 : RankSol, :);
        [~,tmp_Rank]=sort(candidate_firefly(:,Krank+1),'descend');
        % Fill the rest (npop-K) fireflies/solutions up to npop solutions 
        for j = 1:(npop-K), 
            new_Sol(K+j,:)=candidate_firefly(tmp_Rank(j),:);
        end
    end
    % Record and update the current rank after adding new solutions
    K = RankSol;
end

