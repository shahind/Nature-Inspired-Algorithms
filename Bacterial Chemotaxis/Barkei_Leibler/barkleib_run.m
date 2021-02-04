%initial conditions
Ap=0;        %nM
Bp=0;        %nM
Mp=0;        %nM
Yp=0;        %nM
T0=5;        %nM
T1=0;        %nM
T2=0;        %nM
T3=0;        %nM
T4=0;        %nM
To=5;        %nM   
Ao=5;        %nM
Bo=2;        %nM
Mo=5.8;      %nM
Yo=17.9;     %nM    
y0=[Ap Mp Yp Bp T0 T1 T2 T3 T4];
[t, y]=ode23s('barkleib',[0 1000],y0);
figure
grid on
hold on
plot(t,y(:,1),'LineWidth',2)
plot(t,y(:,2),'LineWidth',2)
plot(t,y(:,3),'LineWidth',2)
plot(t,y(:,4),'LineWidth',2)
plot(t,y(:,5),'LineWidth',2)
plot(t,y(:,6),'LineWidth',2)
plot(t,y(:,7),'LineWidth',2)
plot(t,y(:,8),'LineWidth',2)
plot(t,y(:,9),'LineWidth',2)
xlabel('Time (s)')
ylabel('Concentration (nM)')
legend('Ap','Yp','[MYp]','Bp','T0','T1','T2','T3','T4')
hold off
figure
semilogy(t,cligand(t,1),'s')
xlabel('Time (s)')
ylabel('Ligand Conc(nM)')
grid off

figure
Ptot=y(:,1);
Bp=y(:,4);
Yp=y(:,2);
metlevel=(y(:,6)+y(:,7)+y(:,8)+y(:,9))/To;
phoslevel=y(:,1)/Ao;
subplot(2,1,1)
plot(t,phoslevel,'bo');
title('Phosphorylation Level');
xlabel('Time(s)')
subplot(2,1,2)
plot(t,Yp/Yo,'ko');
title('Yp/Ytot');
xlabel('Time(s)')