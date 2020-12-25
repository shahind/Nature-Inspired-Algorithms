% ----------------------------------------------------------------------- % 
% Flower pollenation algorithm (FPA), or flower algorithm                 %
% Programmed by Xin-She Yang @ Feb to May 2012                            % 
% Updated and modified by XS Yang in Sept 2012                            %
% ----------------------------------------------------------------------- %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes: This demo program contains the very basic components of          %
% the flower pollination algorithm (FPA), or flower algorithm (FA),       % 
% for single objective optimization.    It usually works well for         %
% unconstrained functions only. For functions/problems with               % 
% limits/bounds and constraints, constraint-handling techniques           %
% should be implemented to deal with constrained problems properly.       %
%                                                                         %    
% References -- citation details:                                         % 
% 1) Xin-She Yang, Flower pollination algorithm for global optimization,  %
%    Unconventional Computation and Natural Computation,                  %
%    Lecture Notes in Computer Science, Vol. 7445, pp. 240-249 (2012).    %
% 2) X. S. Yang, M. Karamanoglu, X. S. He, Multi-objective flower         %
%    algorithm for optimization, Procedia in Computer Science,            %
%    vol. 18, pp. 861-868 (2013).                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [best,fmin,N_iter]=fpa_demo_new(para)
if nargin<1,
   para=[20 0.8];    % Default parameters for n and p
end
n=para(1);           % Population size, typically 20 to 40
p=para(2);           % The probabibility of switch
% Iteration parameters
N_iter=5000;         % Total number of iterations

% Dimension of the search variables
d=10;
Lb=-10*ones(1,d);     % Lower bounds
Ub=10*ones(1,d);      % Upper bounds
% Initialize the population/solutions
for i=1:n,
  Sol(i,:)=Lb+(Ub-Lb).*rand(1,d);
  Fitness(i)=Fun(Sol(i,:));
end

% Find the current best among the initial population
[fmin,I]=min(Fitness);
best=Sol(I,:);
S=Sol; 

% Start the main iterations -- Flower Pollination Algorithm 
for t=1:N_iter,
        % Loop over all bats/solutions
        for i=1:n,
          % Pollens are carried by insects and thus can move on large scale
          % This L should be drawn from the Levy distribution  
          % Formula: x_i^{t+1}=x_i^t+ L (x_i^t-gbest)
          if rand>p,     % Probability (p) is checked after drawing a rand
          L=Levy(d);     % Draw random numbers from a Levy distribution
          % The main search mechanism via flower pollination
          dS=L.*(Sol(i,:)-best);      % Caclulate the step increments
          S(i,:)=Sol(i,:)+dS;         % Update the new solutions
          % Check new solutions to satisfy the simple limits/bounds
          S(i,:)=simplebounds(S(i,:),Lb,Ub);
          % Another search move via local pollenation of neighbor flowers 
          else
              epsilon=rand;
              % Find random pollen/flowers in the neighbourhood
              JK=randperm(n);
              % As they are random, the first two entries also random
              % If the flower are the same or similar species, then
              % they can be pollenated, otherwise, no action is needed.
              % Formula: x_i^{t+1}+epsilon*(x_j^t-x_k^t)
              S(i,:)=S(i,:)+epsilon*(Sol(JK(1),:)-Sol(JK(2),:));
              % Check if the simple limits/bounds are met
              S(i,:)=simplebounds(S(i,:),Lb,Ub);
          end
          
          % Evaluate the objective values of the new solutions
           Fnew=Fun(S(i,:));
          % If fitness improves (better solutions found), update then
            if (Fnew<=Fitness(i)),
                Sol(i,:)=S(i,:);
                Fitness(i)=Fnew;
           end
           
          % Update the current global best among the population
          if Fnew<=fmin,
                best=S(i,:);
                fmin=Fnew;
          end
        end
        % Display results every 100 iterations
        if ~mod(t,100),
        disp(strcat('Iteration t=',num2str(t)));
        % best
        fmin
        end     
end  % End of the main iterations
%% Output/display the final results
disp(['Total number of evaluations: ',num2str(N_iter*n)]);
disp(['Best solution=',num2str(best)]);
disp(['fmin=',num2str(fmin)]);
  
% Application of simple lower bounds and upper bounds
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

% Draw n samples for the Levy flight from the Levy distribution
function L=Levy(d)
% For details of the Levy flights, see Chapter 11 of the following book:
% Xin-She Yang, Nature-Inspired Optimization Algorithms, Elsevier, (2014).
beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
% Mantegna's algorithm for Levy random numbers
u=randn(1,d)*sigma;
v=randn(1,d);
step=u./abs(v).^(1/beta);
L=0.01*step;             % Final Levy steps

% The Ackley function as the objective function 
function z=Fun(u)
d=length(u);
% The Ackley function has the global minimum fmin=0 at (0,0,...,0)
z=-20*exp(-0.2*sqrt((sum(u.^2))/d))-exp(sum(cos(2*pi*u))./d)+20+exp(1);  

