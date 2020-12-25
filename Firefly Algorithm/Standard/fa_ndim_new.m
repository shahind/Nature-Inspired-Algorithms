% ---------------------------------------------------------------------- %
% The Firefly Algorithm (FA) for unconstrained function optimization     %
% by Xin-She Yang (Cambridge University) @2008-2009                      %
% Programming dates: 2008-2009, then revised and updated in Oct 2010     %
% ---------------------------------------------------------------------- %

% References -- citation details: -------------------------------------- %
% (1) Xin-She Yang, Nature-Inspired Metaheuristic Algorithms,            %
%     Luniver Press, First Edition, (2008).                              %
% (2) Xin-She Yang, Firefly Algorithm, Stochastic Test Functions and     %
%     Design Optimisation, Int. Journal of Bio-Inspired Computation,     %
%     vol. 2, no. 2, 78-84 (2010).                                       %
% ---------------------------------------------------------------------- %

% -------- Start the Firefly Algorithm (FA) main loop ------------------ % 
function fa_ndim_new 
n=20;                   % Population size (number of fireflies)
alpha=1.0;              % Randomness strength 0--1 (highly random)
beta0=1.0;              % Attractiveness constant
gamma=0.01;             % Absorption coefficient
theta=0.97;             % Randomness reduction factor theta=10^(-5/tMax) 
d=10;                   % Number of dimensions
tMax=500;               % Maximum number of iterations
Lb=-10*ones(1,d);       % Lower bounds/limits
Ub=10*ones(1,d);        % Upper bounds/limits
% Generating the initial locations of n fireflies
for i=1:n,
   ns(i,:)=Lb+(Ub-Lb).*rand(1,d);         % Randomization
   Lightn(i)=cost(ns(i,:));               % Evaluate objectives
end

%%%%%%%%%%%%%%%%% Start the iterations (main loop) %%%%%%%%%%%%%%%%%%%%%%%
for k=1:tMax,        
 alpha=alpha*theta;     % Reduce alpha by a factor theta
 scale=abs(Ub-Lb);      % Scale of the optimization problem
% Two loops over all the n fireflies
for i=1:n,
    for j=1:n,
      % Evaluate the objective values of current solutions
      Lightn(i)=cost(ns(i,:));           % Call the objective
      % Update moves
      if Lightn(i)>=Lightn(j),           % Brighter/more attractive
         r=sqrt(sum((ns(i,:)-ns(j,:)).^2));
         beta=beta0*exp(-gamma*r.^2);    % Attractiveness
         steps=alpha.*(rand(1,d)-0.5).*scale;
      % The FA equation for updating position vectors
         ns(i,:)=ns(i,:)+beta*(ns(j,:)-ns(i,:))+steps;
      end
   end % end for j
end % end for i

% Check if the new solutions/locations are within limits/bounds
ns=findlimits(n,ns,Lb,Ub);
%% Rank fireflies by their light intensity/objectives
[Lightn,Index]=sort(Lightn);
nsol_tmp=ns;
for i=1:n,
 ns(i,:)=nsol_tmp(Index(i),:);
end
%% Find the current best solution and display outputs
fbest=Lightn(1), nbest=ns(1,:)
end % End of the main FA loop (up to tMax) 

% Make sure that new fireflies are within the bounds/limits
function [ns]=findlimits(n,ns,Lb,Ub)
for i=1:n,
  nsol_tmp=ns(i,:);
  % Apply the lower bound
  I=nsol_tmp<Lb;  nsol_tmp(I)=Lb(I);
  % Apply the upper bounds
  J=nsol_tmp>Ub;  nsol_tmp(J)=Ub(J);
  % Update this new move
  ns(i,:)=nsol_tmp;
end

%% Define the objective function or cost function
function z=cost(x)
% The modified sphere function: z=sum_{i=1}^D (x_i-1)^2
z=sum((x-1).^2); % The global minimum fmin=0 at (1,1,...,1)
% -----------------------------------------------------------------------%