function [bestX, bestFitness, bestFitnessEvolution,nEval]=BH_v1(options)
%--------------------------------------------------------------------------
% Black Hole Algorithm
% Dr Hpussem BOUCHEKARA
% 20/07/2019
%--------------------------------------------------------------------------
% 1. Bouchekara, H. R. E. H. (2013). Optimal design of electromagnetic
% devices using a black-Hole-Based optimization technique. IEEE
% Transactions on Magnetics, 49(12). doi:10.1109/TMAG.2013.2277694
%
% 2. Bouchekara, H. R. E. H. (2014). Optimal power flow using black-hole-based
% optimization approach. Applied Soft Computing, 24, 879–888.
% doi:10.1016/j.asoc.2014.08.056
%
% 3. Smail, M. K., Bouchekara, H. R. E. H., Pichon, L., Boudjefdjouf, H.,
% Amloune, A., & Lacheheb, Z. (2016). Non-destructive diagnosis of wiring
% networks using time domain reflectometry and an improved black hole
% algorithm. Nondestructive Testing and Evaluation.
% doi:10.1080/10589759.2016.1200576
%--------------------------------------------------------------------------
% Initialize a population of stars with random locations in the search space
% Loop
%   For each star, evaluate the objective function
%   Select the best star that has the best fitness value as the black hole
%   Change the location of each star according to Eq. (3)
%   If a star reaches a location with lower cost than the black hole, exchange their locations
%   If a star crosses the event horizon of the black hole, replace it with a new star in a random location in the search space
%   If a termination criterion (a maximum number of iterations or a sufficiently good fitness) is met, exit the loop
% End loop
%--------------------------------------------------------------------------

ObjFunction=options.ObjFunction; % the name of the objective function
n=options.n;    % dimension of the problem.
uk=options.uk;   % upper bound in the kth dimension.
lk=options.lk;  % lower bound in the kth dimension.
m=options.m; % m: number of sample points
MAXITER=options.MAXITER; % MAXITER: maximum number of iterations
nEval=0;
[x,xBH,iBH,ObjFunctionValue]=Initialize(options);
nEval=nEval+size(x,1);
for iteration =1:MAXITER
    %     tic
    %     Change the location of each star according to Eq. (3)
    for i = 1 : m
        if i ~= iBH
            landa=rand;
            for k = 1 : n
                if landa<0.5
                    x(i,k)=x(i,k) + rand*(xBH(k)- x(i,k));
                else
                    x(i,k)=x(i,k) + rand*(xBH(k)- x(i,k));
                end
            end
        end
    end
    %   If a star reaches a location with lower cost than the black
    %   hole, exchange their locations
    ObjFunctionValue=feval(ObjFunction,x);
    nEval=nEval+size(x,1);
    %     [x]=bound(x,lk,uk);
    %     [xBH,iBH]=argmin(x,ObjFunctionValue,options);
    %   If a star crosses the event horizon of the black hole, replace it
    %   with a new star in a random location in the search space
    R=ObjFunctionValue(iBH)/sum(ObjFunctionValue);
    %     R=exp(-n*ObjFunctionValue(iBH)/sum(ObjFunctionValue))
    %     pause
    for i = 1 : m
        Distance(i)=norm(xBH- x(i,:));
    end
    [x,ObjFunctionValue]=NewStarGeneration(x,Distance,R,options,iBH,ObjFunctionValue);
    [x]=bound(x,lk,uk);
    [xBH,iBH]=argmin(x,ObjFunctionValue,options);
    
    %--------------------------------------------------------------------------------
    bestFitnessEvolution(iteration)=ObjFunctionValue(iBH);
    %--------------------------------------------------------------------------------
    
    
    if options.Display_Flag==1
        fprintf('Iteration N° is %g Best Fitness is %g\n',iteration,ObjFunctionValue(iBH))
    end
    
end
bestX=xBH;
bestFitness=ObjFunctionValue(iBH);
end

function [x,xBH,iBH,ObjFunctionValue]=Initialize(options)
ObjFunction=options.ObjFunction; % the name of the objective function.
n=options.n;    % n: dimension of the problem.
uk=options.uk;  % up: upper bound in the kth dimension.
lk=options.lk;  % lp: lower bound in the kth dimension.
m=options.m;    % m: number of sample points

for i = 1 : m
    for k = 1 : n
        landa=rand;
        x(i,k) = lk(k) + landa*(uk(k) - lk(k));
    end
end
% x(end+1,:)=x0;
ObjFunctionValue=feval(ObjFunction,x);
[index1,index2]=sort(ObjFunctionValue);
x=x(index2(1:m),:);
xBH=x(1,:);
iBH=1;
ObjFunctionValue=ObjFunctionValue(index2(1:m));
end

function [xb,ib,xw,iw]=argmin(x,f,options)
[minf,ib]=min(f);
xb=x(ib,:);
[maxf,iw]=max(f);
xw=x(iw,:);
end


function [x,ObjFunctionValue]=NewStarGeneration(x,Distance,R,options,iBH,ObjFunctionValue)
ObjFunction=options.ObjFunction; % the name of the objective function.
n=options.n;    % n: dimension of the problem.
uk=options.uk;  % up: upper bound in the kth dimension.
lk=options.lk;  % lp: lower bound in the kth dimension.
index=find(Distance<R);
for i=1:length(index)
    if index(i) ~= iBH
        for k = 1 : n
            x(i,k) = lk(k) + rand*(uk(k) - lk(k));
        end
        ObjFunctionValue(i)=feval(ObjFunction,x(i,:));
    end
end
end
function [x]=bound(x,l,u)
for j = 1:size(x,1)
    for k = 1:size(x,2)
        % check upper boundary
        if x(j,k) > u(k),
            x(j,k) = u(k);
        end
        % check lower boundary
        if x(j,k) < l(k),
            x(j,k) = l(k);
        end
    end
end
end