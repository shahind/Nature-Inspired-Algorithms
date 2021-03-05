clear all
%It is used as example the function:
funstr='exp(-((x-4)^2)-((y-4)^2))+exp(-((x+4)^2)-((y-4)^2))+2*(exp(-(x^2+y^2))+exp(-(x^2)-(y+4)^2))';
%It has 4 maxima, 2 sub-optimal and 2 optimal

% Converting to an inline function
f=vectorize(inline(funstr));

%Ranges
range=[-5 5 -5 5];

%Number of B best positions 
Mbest=4;
n=20; %Np=n, Population size
Fa=2;%Perturbation size of v

Hp=0.2; %Probability H
MaxGeneration=100;
Ndiv=100;
dx=(range(2)-range(1))/Ndiv; dy=(range(4)-range(3))/Ndiv;
[x,y] =meshgrid(range(1):dx:range(2),range(3):dy:range(4));
z=f(x,y);
% Display the shape of the objective function
figure(1);   surfc(x,y,z);

%Euation 3.5
%Dominance ratio
rho=((range(2)-range(1))+(range(4)-range(3)))/(10*2);

xrange=range(2)-range(1);
yrange=range(4)-range(3);
pxn=rand(1,n)*xrange+range(1);
pyn=rand(1,n)*yrange+range(3);

pzn=f(pxn,pyn);
[Lightn,Index]=sort(pzn,'descend');
pxn=pxn(Index); pyn=pyn(Index); 

xnini=pxn(1:Mbest);
ynini=pyn(1:Mbest);

znini=f(xnini,ynini);



%INITIALIZATION
xrange=range(2)-range(1);
yrange=range(4)-range(3);
xn=rand(1,n)*xrange+range(1);
yn=rand(1,n)*yrange+range(3);

zn=f(xn,yn);
[Lightn,Index]=sort(zn,'descend');
xn1=xn(Index); yn1=yn(Index);
%---------------------

xbest=xn1(1:Mbest);
ybest=yn1(1:Mbest);



xF=[xnini xbest];
yF=[ynini ybest];


zfin=f(xF,yF);
[Lightn,Index]=sort(zfin,'descend');
xfin=xF(Index); yfin=yF(Index);

xL=xfin(1:Mbest);
yL=yfin(1:Mbest);



figure(2);

%EVOLUTION PROCESS

for i=1:MaxGeneration
    
    for h=1:Mbest
        Vnc(h,:)=[xbest(h) ybest(h)];
               
        Vnh(h,:)=[xL(h) yL(h)];
               
    end
   
    
    for k=1:n
        r=rand;
        if k<=Mbest
            xnp(k)=xL(k)+Fa*((rand-0.5)*2); %Equations 3.2
            ynp(k)=yL(k)+Fa*((rand-0.5)*2);
        elseif (r<Hp)
            Vnc(Mbest+1,:)=[xn(k) yn(k)];
            Ddis = pdist(Vnc);
            DdisM=squareform(Ddis);
            [xcurr,Index]=sort(DdisM(:,Mbest+1),'ascend');
            if (DdisM(Index(2),Mbest+1)==0)
                xcn=xbest(Index(1));
                ycn=ybest(Index(1));
            else
            xcn=xbest(Index(2));
            ycn=ybest(Index(2));
            end
            an=rand;
            xnp(k)=xn(k)+((an-0.5)*2)*(xcn-xn(k));%Equations 3.3
            ynp(k)=yn(k)+((an-0.5)*2)*(ycn-yn(k));
        elseif (r>(1-Hp))
            Vnh(Mbest+1,:)=[xn(k) yn(k)];
            Ddis = pdist(Vnh);
            DdisM=squareform(Ddis);
            [xcurr,Index]=sort(DdisM(:,Mbest+1),'ascend');
            if (DdisM(Index(2),Mbest+1)==0)
                xcn=xL(Index(1));
                ycn=yL(Index(1));
            else
            xcn=xL(Index(2));
            ycn=yL(Index(2));
            end
           an=rand;
            xnp(k)=xn(k)+((an-0.5)*2)*(xcn-xn(k));%Equations 3.3
            ynp(k)=yn(k)+((an-0.5)*2)*(ycn-yn(k));
        else
            xrange=range(2)-range(1);
            yrange=range(4)-range(3);%Equations 3.4
            xnp(k)=rand*xrange+range(1);
            ynp(k)=rand*yrange+range(3);
        end
    end
    
        
    znp=f(xnp,ynp);
    [Lightn,Index]=sort(znp,'descend');
    xn1=xnp(Index); yn1=ynp(Index);
    
    %xn=xnp;
    %yn=ynp;
    
    xn=xn1(n:-1:1);
    yn=yn1(n:-1:1);
    
    %Check if the positions are outside the feasible range
    [xn,yn]=findrange(xn,yn,range);
    
    %UPDATE MEMORY (Section 3.1.5)
    
    H(:,1)=xL;
    H(:,2)=yL;
    fh=f(xL,yL);
    
    C(:,1)=xn;
    C(:,2)=yn;
    
     fc=f(xn,yn);
    
    [VC VH]=ComparaHC(H,fh,C,fc,Mbest,rho);
    
    d1=VC(:,1)';
    d2=VC(:,2)';
    
    xbest=d1(1:Mbest);
    ybest=d2(1:Mbest);
    
    d3=VH(:,1)';
    d4=VH(:,2)';
    
    xF=[d3 d1];
    yF=[d4 d2];
    
    
    
    
    zfin=f(xF,yF);
    [Lightn,Index]=sort(zfin,'descend');
    xfin=xF(Index); yfin=yF(Index);

    xL=xfin(1:Mbest);
    yL=yfin(1:Mbest);

contour(x,y,z,15); hold on;

%Plot results
    
plot(xn,yn,'.','markersize',10,'markerfacecolor','g');
plot(xL,yL,'o','markersize',10,'markerfacecolor','m');
drawnow;

hold off;
    
    
    
end




