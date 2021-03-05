
function Obj=rotation(Obj)
if numel(Obj)<2
    return;
end

global ProblemSettings;
global CFASettings;
CostFunction=ProblemSettings.CostFunction;
% nVar=ProblemSettings.nVar;
% VarMin=ProblemSettings.VarMin;
% VarMax=ProblemSettings.VarMax;
nObj=CFASettings.nObj;
Rotation=CFASettings.Rotation;
if Rotation<rand
    
    
    %%%%% for NObj
    ColCost1=[Obj(1).Point.Cost];
    [AA0, BB0]=sort(ColCost1);
    P1=Obj(1).Point(BB0(end)).Position;
    C1=Obj(1).Point(BB0(end)).Cost;
    GG=Obj(1).Position;
    % NN=Obj(1).Cost;
    
    %    BB1=[];
    
    %%%%%%%%%%%%%%%%
    
    for i=1:nObj-1
        Obj(i).Position=Obj(i+1).Position;
        
        Obj(i).Cost=CostFunction(Obj(i).Position);
        ColCost1=[Obj(i).Point.Cost];
        ColCost2=[Obj(i+1).Point.Cost];
        [AA1, BB1]=sort(ColCost1);
        [AA2, BB2]=sort(ColCost2);
        Obj(i).Point(BB1(end)).Position=Obj(i+1).Point(BB2(end)).Position;
        Obj(i).Point(BB1(end)).Cost=Obj(i+1).Point(BB2(end)).Cost;
        
        % BB1=[];
        % BB2=[];
    end
    % BB3=[];
    ColCost3=[Obj(nObj).Point.Cost];
    [AA2, BB3]=sort(ColCost3);
    Obj(nObj).Point(BB3(end)).Position=P1;
    Obj(nObj).Point(BB3(end)).Cost=C1;
    Obj(nObj).Position= GG;
    Obj(nObj).Cost=CostFunction(Obj(nObj).Position);
    
end


end