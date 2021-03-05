%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Obj=ionization(Obj)

global ProblemSettings;
global CFASettings;

CostFunction=ProblemSettings.CostFunction;
nVar=ProblemSettings.nVar;
VarMin=ProblemSettings.VarMin;
VarMax=ProblemSettings.VarMax;

pIonization=CFASettings.pIonization;

for i=1:numel(Obj)
    cc=[Obj(i).Point.pbc];
    [min_cc, min_cc_index]=min(cc);
    for j=1:Obj(i).nPoint
        if Obj(i).Point(j).Cost>min_cc
            if rand<pIonization
                k=randi([1 nVar]);
                
                Obj(i).Point(j).Position(k)=VarMin(k)+VarMax(k)-Obj(i).Point(j).Position(k);
                
                Obj(i).Point(j).Cost=CostFunction(Obj(i).Point(j).Position);
            end
        end
    end
end

end

