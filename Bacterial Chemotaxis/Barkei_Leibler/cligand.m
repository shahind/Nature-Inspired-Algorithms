function l=cligand(t,n)

switch n
    case 1
        
            
            y =zeros(1,length(t));
            y(t<100) = 1e4;             %nM
            y(t>=100 & t<300) = 1e4;    %nM
            y(t>=300 & t<700) = 2e4;    %nM
            y(t>=700 & t<1000) = 4e4;   %nM
            
            l=y;


    case 2
        y =zeros(1,length(t));
        y(t<200) = 1e2;                 %nM
        y(t>=200) = 1e4;                %nM
        l=y;
    
end
          
        