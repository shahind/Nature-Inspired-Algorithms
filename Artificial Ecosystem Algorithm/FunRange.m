
 
function [Low,Up,Dim]=FunRange(FunIndex)
 
Dim=30;

switch FunIndex
    
    case 1
    Low=-100;Up=100;


    case 2
    Low=-10;Up=10;


    case 3
    Low=-100;Up=100;


    case 4
    Low=-100;Up=100;


    case 5
    Low=-30;Up=30;


    case 6
    Low=-100;Up=100;


    case 7
    Low=-1.28;Up=1.28;


    case 8
    Low=-500;Up=500;


    case 9
    Low=-5.12;Up=5.12;


    case 10
    Low=-32;Up=32;


    case 11
    Low=-600;Up=600;


    case 12
    Low=-50;Up=50;


    case 13
    Low=-50;Up=50;


    case 14
    Low=-65.536;Up=65.536;Dim=2;


    case 15
    Low=-5;Up=5;Dim=4;


    case 16
    Low=-5;Up=5;Dim=2;


    case 17
    Low=[-5 0];Up=[10 15];Dim=2;


    case 18
    Low=-2;Up=2;Dim=2;


    case 19
    Low=0;Up=1;Dim=3;


    case 20
    Low=0;Up=1;Dim=6;


    case 21
    Low=0;Up=10;Dim=4;


    case 22
    Low=0;Up=10;Dim=4;


    otherwise 
    Low=0;Up=10;Dim=4;
    
end

