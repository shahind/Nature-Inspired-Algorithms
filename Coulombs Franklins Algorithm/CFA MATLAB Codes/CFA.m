% Based on the paper:

% Ghasemi, Mojtaba, Sahand Ghavidel, Jamshid Aghaei, Ebrahim Akbari,
% and Li Li. "CFA optimizer: A new and powerful algorithm inspired by
% Franklin's and Coulomb's laws theory for solving the economic load
% dispatch problems." International Transactions on Electrical Energy
% Systems 28, no. 5 (2018): e2536.

clc
clear


%% Problem Definition
CostFunction=@(x) Function(x);

nVar=1000;       % Number of Unknown Variables (a nVar-dimensional problem)
VarMin(:,1:nVar)=-100;
VarMax(:,1:nVar)=-VarMin(:,1:nVar);

%% CFA Settings

nPop=5;             % Number of the population
nObj=round(nPop/5); % Number of Objects  %%%the parameters object size (Nob)
nPoint=nPop-nObj;   % the population value of the group or object
Rotation=0.5;       % contact probabilistic value (Pc) if Nob>1
MaxDecades=300;     % Fitness_evaluations(FEs)= MaxDecades*nPoint
pIonization=0.1;    % Ionization probabilistic value (Pi)


%% Initialization

ShareSettings;

Obj=InitializeObjects();  % Object

BestSol.Position=[];
BestSol.Cost=[];

BestCost=zeros(CFASettings.MaxDecades,1);
MeanCost=zeros(CFASettings.MaxDecades,1);

%% CFA
for Decade=1:MaxDecades
    
    Obj=attraction_repulsion(Obj);
    
    Obj=ionization(Obj);
    
    Obj=Exchange(Obj);
    
    Obj=rotation(Obj);
    
    OBJCost=[Obj.Cost];
    [BestOBJCost, BestOBJIndex]=min(OBJCost);
    BestOBJ=Obj(BestOBJIndex);
    
    BestSol.Position=BestOBJ.Position;
    BestSol.Cost=BestOBJ.Cost;
    
    BestCost(Decade)=BestOBJCost;

    
    disp(['Decade ' num2str(Decade) ...
        ': Best Cost = ' num2str(BestCost(Decade)) ...
        ]);
    
end

hold on
% plot(BestCost,'b','LineWidth',2.0);
plot(log(BestCost),'g','LineWidth',3.0);

save New1


