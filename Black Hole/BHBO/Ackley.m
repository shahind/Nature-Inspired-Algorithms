function [F, lb, ub, FGO] = Ackley(x)
% Ackley function
if (nargin==0)
    F=[];
    d=2;                % dimension
    lb=-32*ones(1,d);   % lower bound
    ub=32*ones(1,d);    % upper bound
    FGO=0;              % Global Optimum
else    
    n=size(x,2);
    for ix=1:size(x,1)
        x0=x(ix,:);
        F(ix) = -20*exp(-0.2*sqrt(1/n*sum(x0.^2)))-...
                    exp(1/n*sum(cos(2*pi*x0)))+20+exp(1);
    end
end