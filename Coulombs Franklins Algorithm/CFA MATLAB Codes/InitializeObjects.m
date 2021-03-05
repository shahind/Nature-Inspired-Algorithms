
function Obj=InitializeObjects()
% Obj: Object

global ProblemSettings;
global CFASettings;

CostFunction=ProblemSettings.CostFunction;
nVar=ProblemSettings.nVar;
VarMin=ProblemSettings.VarMin;
VarMax=ProblemSettings.VarMax;

nPop=CFASettings.nPop;
nObj=CFASettings.nObj;
nPoint=CFASettings.nPoint;

EmptyColony.Position=[];
EmptyColony.Cost=[];
EmptyColony.Delta=[];
EmptyColony.pbp=[];
EmptyColony.pbc=[];
EmptyColony.V=[];
EmptyColony.ij=[];
Point=repmat(EmptyColony,nPop,1);

for k=1:nPop
    Point(k).Position=unifrnd(VarMin,VarMax,[1 nVar]);
    Point(k).Cost=CostFunction(Point(k).Position);
    Point(k).Delta=unifrnd(0,2*pi);
    Point(k).V=.2+unifrnd(-0.5,1);
end


for k2=1:nPop
    Point(k2).pbp=Point(k2).Position;
    Point(k2).pbc=Point(k2).Cost;
    Point(k2).ij=Point(k2).Cost;
end
[SortedCosts, CostsSortOrder]=sort([Point.Cost]); %#ok<ASGLU>
Point=Point(CostsSortOrder);

EmptyObject.Position=[];
EmptyObject.Cost=[];
EmptyObject.TotalCost=[];
EmptyObject.nPoint=[];
EmptyObject.Point=[];
EmptyObject.pbp=[];
EmptyObject.pbc=[];
EmptyObject.V=[];
EmptyObject.ij=[];
Obj=repmat(EmptyObject,nObj,1);
for i=1:nObj
    Obj(i).Position=Point(i).Position;
    Obj(i).Cost=Point(i).Cost;
    Obj(i).Delta=Point(i).Delta;
    Obj(i).pbp=Point(i).pbp;
    Obj(i).pbc=Point(i).pbc;
    Obj(i).V=Point(i).V;
    Obj(i).ij=Point(i).ij;
end

Point=Point(nObj+1:end);
if isempty(Point)
    return;
end

OBJCosts=[Obj.Cost];
MaxOBJCost=max(OBJCosts);
OBJFitness=1.2*MaxOBJCost-OBJCosts;
p=abs(OBJFitness)/sum(abs(OBJFitness));
nc=round(abs(p*nPoint));
snc=sum(nc);

if snc>nPoint
    i=1;
    while snc>nPoint
        nc(i)=max(nc(i)-1,0);
        i=i+1;
        if i>nObj
            i=1;
        end
        snc=sum(nc);
    end
elseif snc<nPoint
    i=nObj;
    while snc<nPoint
        nc(i)=nc(i)+1;
        i=i-1;
        if i<1
            i=nObj;
        end
        snc=sum(nc);
    end
end

Point=Point(randperm(nPoint));

for i=1:nObj
    Obj(i).nPoint=nc(i);
    Obj(i).Point=Point(1:nc(i));
    Point=Point(nc(i)+1:end);
end

end