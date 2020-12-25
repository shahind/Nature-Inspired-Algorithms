clc,clear,close all
warning off
tic
figure(1);hold on

%% ��������
fishnum=100; % ����100ֻ�˹���
MAXGEN=50;   % ����������
try_number=100;  % �����̽����
visual=1;    % ��֪����
delta=0.618; % ӵ��������
step=0.1;    % ����

%% ��ʼ����Ⱥ
lb_ub=[-3,3,2;];
X=AF_init(fishnum,lb_ub);  % ��ʼ��
LBUB=[];
for i=1:size(lb_ub,1)
    LBUB=[LBUB;repmat(lb_ub(i,1:2),lb_ub(i,3),1)];
end
gen=1;
BestY = -1*ones(1,MAXGEN); % ÿ�������ŵĺ���ֵ
BestX = -1*ones(2,MAXGEN); % ÿ�������ŵ��Ա���
besty = -100;              % ���ź���ֵ
Y=AF_foodconsistence(X);   % ���Ż�Ŀ�꺯��
while gen<=MAXGEN
    disp(['����������  ',num2str(gen)])
   
    for i=1:fishnum
        % ��Ⱥ��Ϊ
        [Xi1,Yi1]=AF_swarm(X,i,visual,step,delta,try_number,LBUB,Y);
        % ׷β��Ϊ
        [Xi2,Yi2]=AF_follow(X,i,visual,step,delta,try_number,LBUB,Y);
        if Yi1>Yi2
            X(:,i)=Xi1;
            Y(1,i)=Yi1;
        else
            X(:,i)=Xi2;
            Y(1,i)=Yi2;
        end
    end
   
    [Ymax,index]=max(Y);
    figure(1);
    plot(X(1,index),X(2,index),'.','color',[gen/MAXGEN,0,0])
    if Ymax>besty
        besty=Ymax;
        bestx=X(:,index);
        BestY(gen)=Ymax;
        [BestX(:,gen)]=X(:,index);
    else
        BestY(gen)=BestY(gen-1);
        [BestX(:,gen)]=BestX(:,gen-1);
    end
    gen=gen+1;
   
end
plot(bestx(1),bestx(2),'ro','MarkerSize',100)
xlabel('x')
ylabel('y')
title('��Ⱥ�㷨�������������������ƶ�')

%% �Ż�����ͼ
figure
plot(1:MAXGEN,BestY)
xlabel('��������')
ylabel('�Ż�ֵ')
title('��Ⱥ�㷨��������')
disp(['���Ž�X�� ',num2str(bestx','%1.5f   ')])
disp(['���Ž�Y�� ',num2str(besty,'%1.5f\n')])
toc

%% ��ͼ��ʾ
figure('color',[1,1,1])
peaks
hold on
plot3(bestx(1),bestx(2),besty,'b.','Markersize',40)