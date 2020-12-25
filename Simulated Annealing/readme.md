# this is a sub-directory of Nature-Inspired Algorithms repository in order to see the full list of algorithms please go to https://github.com/shahind/Nature-Inspired-Algorithms

Simulated annealing is an optimization algorithm that skips local minimun. It uses a variation of Metropolis algorithm to perform the search of the minimun. It is recomendable to use it before another minimun search algorithm to track the global minimun instead of a local ones.
Usage: [x0,f0]sim_anl(f,x0,l,u,Mmax,TolFun)

INPUTS:
f = a function handle
x0 = a ninitial guess for the minimun
l = a lower bound for minimun
u = a upper bound for minimun
Mmax = maximun number of temperatures
TolFun = tolerancia de la función

OUTPUTS:
x0 = candidate to global minimun founded
f0 = value of function on x0

Example:

The six-hump camelback function:

camel= @(x)(4-2.1*x(1).^2+x(1).^4/3).*x(1).^2+x(1).*x(2)+4*(x(2).^2-1).*x(2).^2;

has a doble minimun at f(-0.0898,0.7126) = f(0.0898,-0.7126) = -1.0316

this code works with it as follows:

[x0,f0]=sim_anl(camel,[0,0],[-10,-10],[10,10],400)

and we get:
x0=[-0.0897 0.7126]

Reference: 
Héctor Corte (2020). Simulated Annealing Optimization (https://www.mathworks.com/matlabcentral/fileexchange/33109-simulated-annealing-optimization), MATLAB Central File Exchange. Retrieved December 25, 2020.