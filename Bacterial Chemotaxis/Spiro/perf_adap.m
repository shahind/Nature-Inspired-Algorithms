global To
global cligand
clear;
close;
Yo=20e-6;				% M
Bo=2e-6;				% M
Ro=0.3e-6;				% M
Zo=40e-6;				% M

T=1e-6*[1:100];
C=[0 1e-3 1];

Y=[];
X=[];
for j=1:3
    cligand=C(j);
    for i=1:length(T)
        To=T(i);
        dum=perf_adap_func(To,cligand);
        Y=[Y dum(end)];
        X=[X T(i)];
    end
    semilogx(X,Y,'LineWidth',2)
    ylabel('Steady state CheYp activity (M)')
    xlabel('Total Receptor Concentration (M)')
    hold on
    Y=[];
    X=[];
end
legend('0 M Aspartate','1e-3 M Aspartate','1 M Aspartate')
