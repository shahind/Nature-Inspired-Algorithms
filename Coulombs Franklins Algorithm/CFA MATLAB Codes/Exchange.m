

function Obj=Exchange(Obj)

for i=1:numel(Obj)
    
    cc=[Obj(i).Point.Cost];
    [min_cc, min_cc_index]=min(cc);
    
    if min_cc<=Obj(i).Cost
        
        BestColony=Obj(i).Point(min_cc_index);
        
        Obj(i).Point(min_cc_index).Position=Obj(i).Position;
        Obj(i).Point(min_cc_index).Cost=Obj(i).Cost;
        Obj(i).Point(min_cc_index).pbp=Obj(i).pbp;
        Obj(i).Point(min_cc_index).pbc=Obj(i).pbc;
        Obj(i).Point(min_cc_index).Delta=Obj(i).Delta;
        Obj(i).Point(min_cc_index).V=Obj(i).V;
        
        Obj(i).Position=BestColony.Position;
        Obj(i).Cost=BestColony.Cost;
        Obj(i).Delta=BestColony.Delta;
        Obj(i).pbp=BestColony.pbp;
        Obj(i).pbc=BestColony.pbc;
        Obj(i).V=BestColony.V;
    end
    
end

end