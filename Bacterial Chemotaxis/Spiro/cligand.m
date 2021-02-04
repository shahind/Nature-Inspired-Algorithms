function l=cligand(t,n)

switch n
    case 1
        y = zeros(1,length(t));
        y(t<10) = 1e-6;             %M
        y(t>=10 & t<20) = 1e-6;     %M
        y(t>=20 & t<60) = 4e-6;     %M
        y(t>=60 & t<100) = 16e-6;   %M
        l=y;
        
    case 2
        y = zeros(1,length(t));
        y(t<10) = 1e-6;             %M
        y(t>=10 & t<20) = 1e-6;     %M
        y(t>=20 & t<50) = 1e-3;     %M
        y(t>=50) = 1e-6;            %M

        l=y;
    
end
          
        