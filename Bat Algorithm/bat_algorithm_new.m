% ----------------------------------------------------------------------- %
% The bat algorithm (BA) for continuous function optimization (demo)      %
% Programmed by Xin-She Yang @Cambridge University 2010                   %
% ----------------------------------------------------------------------- %

% References: ----------------------------------------------------------- %
% 1) Yang X.S. (2010). A New Metaheuristic Bat-Inspired Algorithm, In:    %
%   Nature-Inspired Cooperative Strategies for Optimization (NICSO 2010), %
%   Studies in Computational Intelligence, vol 284. Springer, Berlin.     %
%   https://doi.org/10.1007/978-3-642-12538-6_6                           %
% 2) Yang X.S. (2014). Nature-Inspired Optimization Algorithms, Elsevier. %
% ----------------------------------------------------------------------- %

function [best,fmin,N_iter]=bat_algorithm_new(inp)
if nargin<1,
   inp=[20 1000];    % Default values for n=10 and t_max=1000
end
% Initialize all the default parameters
n=inp(1);       % Population size, typically 20 to 40 
t_max=inp(2);   % Maximum number of iterations
A=1;            % Initial loudness (constant or decreasing)
r0=1;           % The initial pulse rate (constant or decreasing)
alpha=0.97;     % Parameter alpha
gamma=0.1;      % Parameter gamma
% Frequency range
Freq_min=0;     % Frequency minimum
Freq_max=2;     % Frequency maximum
t=0;            % Initialize iteration counter
% Dimensions of the search variables
d=10;          
% Initialization of all the arrays
Freq=zeros(n,1);   % Frequency-tuning array
v=zeros(n,d);      % Equivalnet velocities or increments
Lb=-5*ones(1,d);   % Lower bounds
Ub=5*ones(1,d);    % Upper bounds
% Initialize the population/solutions
for i=1:n,
  Sol(i,:)=Lb+(Ub-Lb).*rand(1,d);
  Fitness(i)=Fun(Sol(i,:));
end
% Find the best solution of the initial population
[fmin,I]=min(Fitness);
best=Sol(I,:);

% Start the iterations -- the Bat Algorithm (BA) -- main loop
while (t<t_max)
   % Varying loundness (A) and pulse emission rate (r)
   r=r0*(1-exp(-gamma*t));
   A=alpha*A;
   % Loop over all bats/solutions
   for i=1:n,
       Freq(i)=Freq_min+(Freq_max-Freq_min)*rand;
       v(i,:)=v(i,:)+(Sol(i,:)-best)*Freq(i);
       S(i,:)=Sol(i,:)+v(i,:);
   % Check a switching condition
   if rand<r,
       S(i,:)=best+0.1*randn(1,d)*A;
   end

   % Check if the new solution is within the simple bounds
   S(i,:)=simplebounds(S(i,:),Lb,Ub);
   % Evaluate new solutions
   Fnew=Fun(S(i,:));
   % If the solution improves or not too loudness
    if ((Fnew<=Fitness(i)) & (rand>A)),
       Sol(i,:)=S(i,:);
       Fitness(i)=Fnew;
    end
   % Update the current best solution
    if Fnew<=fmin,
       best=S(i,:);
       fmin=Fnew;
    end
   end % end of for i
  t=t+1;  % Update iteration counter
  % Display the results every 100 iterations
  if ~mod(t,100),
     disp(strcat('Iteration = ',num2str(t)));    
     best, fmin 
  end
end  % End of the main loop

% Output the best solution
disp(['Best =',num2str(best),' fmin=',num2str(fmin)]);

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

% The cost function or objective function
function z=Fun(x)
z=sum((x-2).^2);      % Optimal solution fmin=0 at (2,2,...,2)