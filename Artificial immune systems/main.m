function [ L , C ] = main( antigen, L, C )
%MAIN Summary of this function goes here
%   Detailed explanation goes here


fid = fopen('antibody.txt','rt');
tmp = textscan(fid, '%s %s %s %s %s');
AA=affinity_aa(tmp);
NA=neg_affinity(tmp);
AN=affinity_ag(tmp,antigen);
display('Antigen Affinity Vector');
AN
display('Affinity Matrix Matrix');
AA
display('Negative Affinity Matrix');
NA
display('Initiall concentration of Antibodies');
C
D=Farmer(C, AA, NA, AN);
display('Concentration change Vector');
D
L=link(L, D, AA,50);
for i=1:50
    if (C(i)<30 && C(i)> 0)
    C(i)=C(i)+D(i);
    end
end
display('Order Matrix');
L
display('Concentration after antigen Stimulation:');
C
end

