% ======================================================== % 
% Files of the Matlab programs included in the following paper:       %
% Xiangyuan Jiang and Shuai Li, BAS: Beetle Antennae Search Algorithm for Optimization Problems, arXiv:1710.10724v1    %
% ======================================================== %    


% =========================================================% 
% BAS by Xiangyuan Jiang and Shuai Li (The Hong Kong Polytechnic University)     %
% 
% This is a demo for 2-D functions.
% ======================================================== %
function BAS()
%bas:beetle antenna searching for global minimum 
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parameter setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%antenna distance
d0=0.001;
d1=3;
d=d1;
eta_d=0.95;
%random walk
l0=0.0;
l1=0.0;
l=l1;
eta_l=0.95;
%steps
step=0.8;%step length
eta_step=0.95;
n=100;%iterations
k=2;%space dimension
x0=2*rands(k,1);
x=x0;
xbest=x0;
fbest=fun(xbest);
fbest_store=fbest;
x_store=[0;x;fbest];
display(['0:','xbest=[',num2str(xbest(1)),num2str(xbest(2)),'],fbest=',num2str(fbest)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:n
    dir=rands(k,1);
    dir=dir/(eps+norm(dir));
    xleft=x+dir*d;
    fleft=fun(xleft);
    xright=x-dir*d;
    fright=fun(xright);
    w=l*rands(k,1);
    x=x-step*dir*sign(fleft-fright)+w;
    f=fun(x);
    %%%%%%%%%%%
    if f<fbest
        xbest=x;
        fbest=f;
    end
    %%%%%%%%%%%
    x_store=cat(2,x_store,[i;x;f]);
    fbest_store=[fbest_store;fbest];
    display([num2str(i),':xbest=[',num2str(xbest(1)),num2str(xbest(2)),'],fbest=',num2str(fbest)])
    %%%%%%%%%%%
    d=d*eta_d+d0;
    l=l*eta_l+l0;
    step=step*eta_step;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%data visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1),clf(1),
plot(x_store(2,:),x_store(3,:),'r-.'),axis equal
xlim0=[min(x_store(2,:)),max(x_store(2,:))];
ylim0=[min(x_store(3,:)),max(x_store(3,:))];
[x,y]=meshgrid(xlim0(1):(xlim0(2)-xlim0(1))/50:xlim0(2),ylim0(1):(ylim0(2)-ylim0(1))/50:ylim0(2));
f_val=x;
[s1,s2]=size(x);
for i=1:s1
    for j=1:s2
f_val(i,j)=fun([x(i,j),y(i,j)]);
    end
end
hold on,contour(x,y,f_val,50);
  colorbar;
xlim([xlim0(1),xlim0(2)]);
ylim([ylim0(1),ylim0(2)]);
hold on, plot(x_store(2,end),x_store(3,end),'b*')
hold on, plot(xbest(1),xbest(2),'r*')


figure(3),clf(3),
plot(x_store(1,:),x_store(4,:),'r-o')
hold on,
plot(x_store(1,:),fbest_store,'b-.')
xlabel('iteration')
ylabel('minimum value')
end
function yout=fun(x)

theta=x;
x=theta(1);
y=theta(2);
% Michalewicz function
yout=-sin(x).*(sin(x.^2/pi)).^20-sin(y).*(sin(2*y.^2/pi)).^20;

end
