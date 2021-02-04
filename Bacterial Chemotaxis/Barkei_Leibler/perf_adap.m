global To
global cligand
clear;
close;

T=1e-1*[1:100];
C=[0 1e4 1e9];

Y=[];
X=[];
A=[];
B=[];
for j=1:3
    cligand=C(j);
    for i=1:length(T)
        To=T(i);
        dum=perf_adap_func(To,cligand);
        Y=[Y dum(end)];
        X=[X T(i)];
    end
    A=[A; X];
    B=[B; Y];
    
    Y=[];
    X=[];
end

loglog(A(1,:),B(1,:),'s')
hold on
loglog(A(1,:),B(2,:),'o')
hold on
loglog(A(1,:),B(3,:),'>')
xlabel('Total Receptor Concentration [nM]')
ylabel('Steady state activity [nM]')
legend('0 M Aspartate','1e-5 M Aspartate','1 M Aspartate')
