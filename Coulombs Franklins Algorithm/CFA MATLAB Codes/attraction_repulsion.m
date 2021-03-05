
function Obj=attraction_repulsion(Obj)

global ProblemSettings;
global CFASettings;

CostFunction=ProblemSettings.CostFunction;
VarMin=ProblemSettings.VarMin;
VarMax=ProblemSettings.VarMax;
nVar=ProblemSettings.nVar;
pIonization=CFASettings.pIonization;
D2=nVar;

%%%%%%%%%%%%

for i=1:numel(Obj)
    BB=[];
    % AA=[];
    % CC=[];
    % DD=[];
    % e11=[];
    Cot=[];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for e11=1:Obj(i).nPoint
        Cot(e11)= Obj(i).Point(e11).Cost;
    end
    [AAz, BBz]=sort(Cot);
    BB(i,:)=BBz;
    
    for j=1:Obj(i).nPoint
        % NE=[];
        % NE0=[];
        mean1(1, 1:D2)=[0];
        mean2(1, 1:D2)=[0];
        qq=Obj(i).Point(j).Position;
        NE1=Obj(i).nPoint+1;
        NE2=Obj(i).nPoint+1;
        
        
        
        NE= (NE1)+(NE2)*(cos(Obj(i).Point(j).Delta));
        NE0=(NE1)-(NE2)*(cos(Obj(i).Point(j).Delta));
        
        NE= round(NE);
        NE0=round(NE0);
        %%%%%%%%%%%%%%%%%%55
        %%%%%%%%%%%%%%%%%%55
        %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%555
        
        [s1, d1]= find (BB(i,:)==j);
        % we=[];
        % wo=[];
        
        % hh=[];
        % ze=[];
        
        we=BB(i,1:d1-1);
        wo=BB(i,d1+1:end-1);
        %%%%%%%%%%%%%%%%%%
        
        %
        [gg, hh]=size(we);
        
        if hh>NE
            hh=NE;
        end
        % k=[];
        % k1=[];
        for k=1:hh
            k1=round(1+(hh-1)*rand);
            mean1(k,:)=(Obj(i).Point(we(k1)).Position) ;
        end
        
        [zx, ze]=size(wo);
        if ze>NE0
            ze=NE0;
        end
        % k=[];
        % k1=[];
        for k=1:ze
            k1=round(1+(ze-1)*rand);
            mean2(k,:)=(Obj(i).Point(wo(k1)).Position) ;
            
        end
        Obj(i).Point(j).Position=qq;
        
        
        gh=cos(Obj(i).Point(j).Delta);
        if size(gh,1)==0
            Obj(i).Point(j).Delta=unifrnd(0,2*pi);
        end
        Obj(i).Point(j).Position=qq;
        %
        L1=(mean(mean1)-mean(mean2));
        G1=(Obj(i).Position-Obj(i).Point(BB(i,end)).Position);
        ff=cos(Obj(i).Point(j).Delta);
        uu=sin(Obj(i).Point(j).Delta);
        MUG=(Obj(i).Point(j).Position)+((abs(ff)^(2)).*(G1))+((abs(uu)^(2)).*(L1));
        
        % CO=[];
        CO=MUG;
        CO=min(max( CO,VarMin),VarMax);
        
        CostCO=CostFunction(CO);
        
        if CostCO<Obj(i).Point(j).Cost
            Obj(i).Point(j).Position=CO;
            Obj(i).Point(j).Cost=CostCO;
        end
        
        
        
        Obj(i).Point(j).Delta=Obj(i).Point(j).Delta+unifrnd(0,1.5*pi);
        %  if Obj(i).Point(j).Cost<Obj(i).Point(j).pbc
        Obj(i).Point(j).pbp=Obj(i).Point(j).Position;
        Obj(i).Point(j).pbc=Obj(i).Point(j).Cost;
        
        %  end
        
    end
    
end
end




