function X=AF_init(Nfish,lb_ub)
%���룺
% Nfish ��Ⱥ��С
% lb_ub ��Ļ��Χ
%�����
% X     �����ĳ�ʼ�˹���Ⱥ

% Nfish=3;
% lb_ub=[-3.0,12.1,1;4.1,5.8,1];
%%�����lb_ub��2��3�еľ���ÿ����ǰ�������Ƿ�Χ�������ޣ���3�������ڸ÷�Χ�ڵ����ĸ���
% X=Inital(Nfish,lb_ub)  
%%���ǲ���[-3.0,12.1]�ڵ���1����[4.1,5.8]�ڵ���1��
%%������һ�飬��������һ��Nfish��
row=size(lb_ub,1);
X=[];
for i=1:row
    lb=lb_ub(i,1);
    ub=lb_ub(i,2);
    nr=lb_ub(i,3);
    for j=1:nr
        X(end+1,:)=lb+(ub-lb)*rand(1,Nfish);
    end
end