clear;
close;
Yo=20e-6;				% M
Bo=2e-6;				% M
To=8e-6;				% M
Ro=0.6e-6;				% M
Zo=40e-6;				% M
options = odeset('RelTol',1e-10,'AbsTol',[1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10]);
[t, y]=ode15s('spiro_func',[0 100],[3e-6 1e-6 4e-6 0e-6 0e-6 0.5e-6 10e-6],options);
figure
grid on
hold on
plot(t,y(:,1),'LineWidth',2)
plot(t,y(:,2),'LineWidth',2)
plot(t,y(:,3),'LineWidth',2)
plot(t,y(:,4),'LineWidth',2)
plot(t,y(:,5),'LineWidth',2)
plot(t,To-y(:,1)-y(:,2)-y(:,3)-y(:,4)-y(:,5),'LineWidth',2)
plot(t,y(:,6),'LineWidth',2)
plot(t,y(:,7),'LineWidth',2)
xlim([0 100])
ylim([0 20e-6])
xlabel('Time (s)')
ylabel('Concentration (M)')
title('Concentration profiles of components involved in the chemotaxis')
legend('C2: [T2]+[LT2]','C3: [T3]+[LT3]','C4: [T4]+[LT4]','C2p: [T2p]+[LT2p]','C3p: [T3p]+[LT3p]','C4p: [T4p]+[LT4p]','CheBp','CheYp')
hold off
figure

Ptot=To-y(:,1)-y(:,2)-y(:,3);       %Total concentration of phosphorylated receptors
Bp=y(:,6);                          %Bp 
Yp=y(:,7);                          %Yp
metlevel=1-(y(:,1)+y(:,4))/To;      %Normalized Methylation
phoslevel=1-(y(:,1)+y(:,2)+y(:,3))/To;  %Normalized phosphorylation
% subplot(2,2,1)
% plot(t,phoslevel,'bo');
% axis([10 100 0 0.1]);
% title('Phosphorylation Level');
% xlabel('Time(s)')
% grid on
% subplot(2,2,2)
% plot(t,metlevel,'ro');
% title('Methylation Level');
% axis([10 100 0 1]);
% grid on
% xlabel('Time(s)')
% subplot(2,2,3)
% plot(t,Bp/Bo,'go');
% axis([10 100 0 1]);
% title('Bp/Btot');
% grid on
% xlabel('Time(s)')
% subplot(2,2,4)
plot(t,Yp/Yo,'ko');
axis([10 100 0 1]);
title('Yp/Ytot');
grid on
xlabel('Time(s)')