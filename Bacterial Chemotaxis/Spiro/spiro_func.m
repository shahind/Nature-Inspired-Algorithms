function dydt = f(t,y,flag)

% constants from Table 3 (Spiro et al.)
k1c=0.17;			 	% 1/s
k2c=0.1*k1c;            % 1/s
k3c=30*k1c;				% 1/s
k4c=30*k2c;             % 1/s

ratiok1bk1a=1e-6;     % M
ratiok3ck3a=1.7e-6;     % M

k_1=4e5;					% 1/(Ms)
k_2=3e4;					% 1/(Ms)
k_3=k_1;                    % 1/(Ms)
k_4=k_2;					% 1/(Ms)

k5=7e7;                     % 1/(Ms)
k6=7e7;                     % 1/(Ms)
k7=7e7;                     % 1/(Ms)

k_5=70;                     % 1/(s)
k_6=70;                     % 1/(s)
k_7=70;                     % 1/(s)

k8=15;                      % 1/s
k9=3*k8;					% 1/s
k10=3.2*k8;					% 1/s
k11=0;                      % 1/s
k12=1.1*k8;                 % 1/s
k13=0.72*k10;				% 1/s

%k12=30;
kb=8e5;					% 1/(Ms)
ky=3e7;					% 1/(Ms)
k_b=0.35;				% 1/s
k_y=5e5;				% 1/(Ms)
Kbind=1e6;				% 1/M

Yo=20e-6;				% M
Bo=1.7e-6;				% M
To=8e-6;				% M
Ro=0.3e-6;				% M
Zo=40e-6;				% M


l=cligand(t,1);  %Input for Fold change Detection
%l=cligand(t,2); %Step input   
hold on
semilogy(t,l,'s')
xlabel('Time(s)')
ylabel('Ligand concentration(M)')
title('Chemoattractant concentration function(Spiro model)')



Vmaxub=k1c*Ro;                   % max turnover rate (MM kinetics) for unbound receptors
Vmaxb=k3c*Ro;                     % max turnover rate (MM kinetics) for bound receptors	
Vmaxub_p=k2c*Ro;                 % max turnover rate (MM kinetics) for unbound receptors
Vmaxb_p=k4c*Ro;                   % max turnover rate (MM kinetics) for bound receptors	

KR=ratiok1bk1a;                     % Michaelis constant
kpt=ky*(Yo-y(7))+kb*(Bo-y(6));      %Phosphotransfer rate
 
% Michaelis constant
fb=(Kbind*l)/(1+(Kbind*l));
% fraction receptors bound to ligand

fu=1-fb;
% fraction receptors not bound to ligand 

% [T2]+[LT2] = y(1)
% [T3]+[LT3] = y(2)
% [T4]+[LT4] = y(3)
% [T2p]+[LT2p] = y(4)
% [T3p]+[LT3p] = y(5)
% [T4p]+[LT4p] = (To-y(1)-y(2)-y(3)-y(4)-y(5))
% [Bp] = y(6)
% [Yp] = y(7)

ydot1=(-k8*fu-k11*fb)*y(1)+kpt*y(4)+(k_1*fu+k_3*fb)*y(2)*y(6)-Vmaxub*y(1)*fu/(KR+y(1)*fu)-Vmaxb*y(1)*fb/(KR+y(1)*fb);

ydot2=(-k9*fu-k12*fb)*y(2)+kpt*y(5)-(k_1*fu+k_3*fb)*y(2)*y(6)+(k_2*fu+k_4*fb)*y(3)*y(6)+Vmaxub*y(1)*fu/(KR+y(1)*fu)+Vmaxb*y(1)*fb/(KR+y(1)*fb)-Vmaxub_p*y(2)*fu/(KR+y(2)*fu)-Vmaxb_p*y(2)*fb/(KR+y(2)*fb);

ydot3=(-k10*fu-k13*fb)*y(3)+kpt*(To-y(1)-y(2)-y(3)-y(4)-y(5))-(k_2*fu+k_4*fb)*y(3)*y(6)+Vmaxub_p*y(2)*fu/(KR+y(2)*fu)+Vmaxb_p*y(2)*fb/(KR+y(2)*fb);

ydot4=(k8*fu+k11*fb)*y(1)-kpt*y(4)+(k_1*fu+k_3*fb)*y(5)*y(6)-Vmaxub*y(4)*fu/(KR+y(4)*fu)+Vmaxb*y(4)*fb/(KR+y(4)*fb);

ydot5=(k9*fu+k12*fb)*y(2)-kpt*y(5)-(k_1*fu+k_3*fb)*y(5)*y(6)+(k_2*fu+k_4*fb)*(To-y(1)-y(2)-y(3)-y(4)-y(5))*y(6)+Vmaxub*y(4)*fu/(KR+y(4)*fu)+Vmaxb*y(4)*fb/(KR+y(4)*fb)-Vmaxub_p*y(5)*fu/(KR+y(5)*fu)-Vmaxb_p*y(5)*fb/(KR+y(5)*fb);

ydot6=kb*(To-y(1)-y(2)-y(3))*(Bo-y(6))-k_b*y(6);

ydot7=ky*(To-y(1)-y(2)-y(3))*(Yo-y(7))-k_y*y(7)*Zo;

dydt=[ydot1; ydot2; ydot3; ydot4; ydot5; ydot6; ydot7]; 
