function [VC VH]=ComparaHC(H,fh,C,fc,Mbest,rho)


ix=size(C,1);
flags1=ones(ix,1);
flags2=ones(Mbest,1);
for k1=1:ix
    for k2=1:Mbest
     
        diff=sqrt((C(k1,1)-H(k2,1))^2+(C(k1,2)-H(k2,2))^2);
        
       
        if ((diff<rho)&&(fc(k1)<fh(k2)))
            flags1(k1)=0;
        end
        
        if ((diff<rho)&&(fc(k1)>=fh(k2)))
            flags2(k2)=0;
        end
        
    end
end

Index1=find(flags1);
Index2=find(flags2);

VC=C(Index1,:);
VH=H(Index2,:);

