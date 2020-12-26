

 function Fit=Test_Functions(X,Fun_Index,Dim)
 
 switch Fun_Index
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%unimodal function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  
%Sphere
case 1
Fit=sum(X.^2);

%Schwefel 2.22
case 2 
Fit=sum(abs(X))+prod(abs(X));

%Schwefel 1.2
case 3
    Fit=0;
    for i=1:Dim
    Fit=Fit+sum(X(1:i))^2;
    end

%Schwefel 2.21
case 4
    Fit=max(abs(X));

%Rosenbrock
case 5
    Fit=sum(100*(X(2:Dim)-(X(1:Dim-1).^2)).^2+(X(1:Dim-1)-1).^2);

%Step
case 6
    Fit=sum(floor((X+.5)).^2);

%Quartic
case 7
    Fit=sum([1:Dim].*(X.^4))+rand;


%%%%%%%%%%%%%%%%%%%%%%%%%%multimodal function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Schwefel
case 8
    Fit=sum(-X.*sin(sqrt(abs(X))));

%Rastrigin
case 9
    Fit=sum(X.^2-10*cos(2*pi.*X))+10*Dim;

%Ackley
case 10
    Fit=-20*exp(-.2*sqrt(sum(X.^2)/Dim))-exp(sum(cos(2*pi.*X))/Dim)+20+exp(1);

%Griewank
case 11
    Fit=sum(X.^2)/4000-prod(cos(X./sqrt([1:Dim])))+1;

%Penalized
case 12
  a=10;k=100;m=4;
  Dim=length(X);
  Fit=(pi/Dim)*(10*((sin(pi*(1+(X(1)+1)/4)))^2)+sum((((X(1:Dim-1)+1)./4).^2).*...
        (1+10.*((sin(pi.*(1+(X(2:Dim)+1)./4)))).^2))+((X(Dim)+1)/4)^2)+sum(k.*...
        ((X-a).^m).*(X>a)+k.*((-X-a).^m).*(X<(-a)));

%Penalized2
case 13
  a=10;k=100;m=4;
  Dim=length(X);
  Fit=.1*((sin(3*pi*X(1)))^2+sum((X(1:Dim-1)-1).^2.*(1+(sin(3.*pi.*X(2:Dim))).^2))+...
        ((X(Dim)-1)^2)*(1+(sin(2*pi*X(Dim)))^2))+sum(k.*...
        ((X-a).^m).*(X>a)+k.*((-X-a).^m).*(X<(-a)));

%%%%%%%%%%%%%%%%%%%%%%%%%%fixed-dimensionalmultimodalfunction%%%%%%%%%%%%%%

%Foxholes
case 14
  a=[-32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32;,...
  -32 -32 -32 -32 -32 -16 -16 -16 -16 -16 0 0 0 0 0 16 16 16 16 16 32 32 32 32 32];
    for j=1:25
        b(j)=sum((X'-a(:,j)).^6);
    end
    Fit=(1/500+sum(1./([1:25]+b))).^(-1);

%Kowalik
case 15
    a=[.1957 .1947 .1735 .16 .0844 .0627 .0456 .0342 .0323 .0235 .0246];
    b=[.25 .5 1 2 4 6 8 10 12 14 16];b=1./b;
    Fit=sum((a-((X(1).*(b.^2+X(2).*b))./(b.^2+X(3).*b+X(4)))).^2);

%Six Hump Camel
case 16
    Fit=4*(X(1)^2)-2.1*(X(1)^4)+(X(1)^6)/3+X(1)*X(2)-4*(X(2)^2)+4*(X(2)^4);

%Branin
case 17
    Fit=(X(2)-(X(1)^2)*5.1/(4*(pi^2))+5/pi*X(1)-6)^2+10*(1-1/(8*pi))*cos(X(1))+10;

%GoldStein-Price
case 18
    Fit=(1+(X(1)+X(2)+1)^2*(19-14*X(1)+3*(X(1)^2)-14*X(2)+6*X(1)*X(2)+3*X(2)^2))*...
        (30+(2*X(1)-3*X(2))^2*(18-32*X(1)+12*(X(1)^2)+48*X(2)-36*X(1)*X(2)+27*(X(2)^2)));

%Hartman 3
case 19
  a=[3 10 30;.1 10 35;3 10 30;.1 10 35];c=[1 1.2 3 3.2];
  p=[.3689 .117 .2673;.4699 .4387 .747;.1091 .8732 .5547;.03815 .5743 .8828];
  Fit=0;
  for i=1:4
  Fit=Fit-c(i)*exp(-(sum(a(i,:).*((X-p(i,:)).^2))));
  end

%Hartman 6
case 20
  af=[10 3 17 3.5 1.7 8;.05 10 17 .1 8 14;3 3.5 1.7 10 17 8;17 8 .05 10 .1 14];
  cf=[1 1.2 3 3.2];
  pf=[.1312 .1696 .5569 .0124 .8283 .5886;.2329 .4135 .8307 .3736 .1004 .9991;...
  .2348 .1415 .3522 .2883 .3047 .6650;.4047 .8828 .8732 .5743 .1091 .0381];
  Fit=0;
    for i=1:4
    Fit=Fit-cf(i)*exp(-(sum(af(i,:).*((X-pf(i,:)).^2))));
    end

%Shekel 5
case 21
  a=[4 4 4 4;1 1 1 1;8 8 8 8;6 6 6 6;3 7 3 7;2 9 2 9;5 5 3 3;8 1 8 1;6 2 6 2;7 3.6 7 3.6];
  c=[0.1 0.2 0.2 0.4 0.4 0.6 0.3 0.7 0.5 0.5];
  Fit=0;
  for i=1:5
    Fit=Fit-1/((X-a(i,:))*(X-a(i,:))'+c(i));
  end

%Shekel 7
case 22
  a=[4 4 4 4;1 1 1 1;8 8 8 8;6 6 6 6;3 7 3 7;2 9 2 9;5 5 3 3;8 1 8 1;6 2 6 2;7 3.6 7 3.6];
  c=[0.1 0.2 0.2 0.4 0.4 0.6 0.3 0.7 0.5 0.5];
  Fit=0;
  for i=1:7
    Fit=Fit-1/((X-a(i,:))*(X-a(i,:))'+c(i));
  end

%Shekel 10
  otherwise
  a=[4 4 4 4;1 1 1 1;8 8 8 8;6 6 6 6;3 7 3 7;2 9 2 9;5 5 3 3;8 1 8 1;6 2 6 2;7 3.6 7 3.6];
  c=[0.1 0.2 0.2 0.4 0.4 0.6 0.3 0.7 0.5 0.5];
  Fit=0;
  for i=1:10
    Fit=Fit-1/((X-a(i,:))*(X-a(i,:))'+c(i));
  end

end
 
