function yr = perf_adap_func(To,cligand)
    y0=[0 0 0 0 To 0 0 0 0];
    [t, y]=ode23s(@f,[0 1000],y0);
    

    function dydt=f(t, y)
            dydt=zeros(9,1);

            %constant values
            a0=0;
            a1=0.1;
            a2=0.5;
            a3=0.75;
            a4=1;
            a0l=0;
            a1l=0;
            a2l=0.1;
            a3l=0.5;
            a4l=1;
            kb=0.5;
            Kb=5.5;
            kr=0.255;
            Kr=0.251;
            R=0.3;
            Kl=10000;

            %components as variable names
            Ap=y(1);
            Yp=y(2);
            Mp=y(3);
            Bp=y(4);
            T0=y(5);
            T1=y(6);
            T2=y(7);
            T3=y(8);
            T4=y(9);

            %constraints
            A=5-Ap;
            B=2-Bp;
            M=5.8-Mp;
            Y=17.9-Mp-Yp;

            L=cligand;
%             semilogy(t,L,'s')
%             hold on

            % %ligand impulse
            % L=1e3;
            % if t>200 
            %     L=1e6; 
            % end
            % if t>500
            %     L=1e-2; 
            % end
            % if t>600 
            %     L=1e3; 
            % end

            %probabilities
            alpha(1)=(a0l*L+a0*Kl)/(Kl+L);
            alpha(2)=(a1l*L+a1*Kl)/(Kl+L);
            alpha(3)=(a2l*L+a2*Kl)/(Kl+L);
            alpha(4)=(a3l*L+a3*Kl)/(Kl+L);
            alpha(5)=(a4l*L+a4*Kl)/(Kl+L);

            %Active and Inactive regulators
            Ta=alpha(1)*T0+alpha(2)*T1+alpha(3)*T2+alpha(4)*T3+alpha(5)*T4;
            Ti=(1-alpha(1))*T0+(1-alpha(2))*T1+(1-alpha(3))*T2+(1-alpha(4))*T3+(1-alpha(5))*T4;

            %CheR/CheBp Michaelis-Menten
            rB=kb*Bp/(Kb+Ta);
%             rR=0.75*R;
            rR=kr*R/(Kr+Ti);

            %odes
            dydt(1)=50*Ta*A-100*Ap*Y-30*Ap*B;
            dydt(2)=100*Ap*Y-0.1*Yp-5*M*Yp+19*Mp-30*Yp;
            dydt(3)=5*M*Yp-19*Mp;
            dydt(4)=30*Ap*B-Bp;
            dydt(5)=-(rR*(1-alpha(1))*T0)+(rB*alpha(2)*T1);
            dydt(6)=-(rR*(1-alpha(2))*T1)+(rB*alpha(3)*T2)+(rR*(1-alpha(1))*T0)-(rB*alpha(2)*T1); 
            dydt(7)=-(rR*(1-alpha(3))*T2)+(rB*alpha(4)*T3)+(rR*(1-alpha(2))*T1)-(rB*alpha(3)*T2);
            dydt(8)=-(rR*(1-alpha(4))*T3)+(rB*alpha(5)*T4)+(rR*(1-alpha(3))*T2)-(rB*alpha(4)*T3);
            dydt(9)=(rR*(1-alpha(4))*T3)-(rB*alpha(5)*T4);


    end
    a0=0;
    a1=0.1;
    a2=0.5;
    a3=0.75;
    a4=1;
    a0l=0;
    a1l=0;
    a2l=0.1;
    a3l=0.5;
    a4l=1;
    alpha(1)=(a0l*L+a0*Kl)/(Kl+L);
    alpha(2)=(a1l*L+a1*Kl)/(Kl+L);
    alpha(3)=(a2l*L+a2*Kl)/(Kl+L);
    alpha(4)=(a3l*L+a3*Kl)/(Kl+L);
    alpha(5)=(a4l*L+a4*Kl)/(Kl+L);
%     yr=(alpha(1)*y(:,5))+(alpha(2)*y(:,6))+(alpha(3)*y(:,7))+(alpha(4)*y(:,8))+(alpha(5)*y(:,9));
    yr=y(:,2);
end
