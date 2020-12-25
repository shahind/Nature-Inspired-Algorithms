function [Xnext,Ynext]=AF_swarm(X,i,visual,step,deta,try_number,LBUB,lastY)
% ��Ⱥ��Ϊ
%���룺
%X           �����˹����λ��
%i           ��ǰ�˹�������
%visual      ��֪��Χ
%step        ����ƶ�����
%deta        ӵ����
%try_number  ����Դ���
%LBUB        ��������������
%lastY       �ϴεĸ��˹���λ�õ�ʳ��Ũ��

%�����
%Xnext       Xi�˹������һ��λ��  
%Ynext       Xi�˹������һ��λ�õ�ʳ��Ũ��
Xi=X(:,i);
D=AF_dist(Xi,X);
index=find(D>0 & D<visual);
nf=length(index);
if nf>0
    for j=1:size(X,1)
        Xc(j,1)=mean(X(j,index));
    end
    Yc=AF_foodconsistence(Xc);
    Yi=lastY(i);
    if Yc/nf>deta*Yi
        Xnext=Xi+rand*step*(Xc-Xi)/norm(Xc-Xi);
        for i=1:length(Xnext)
            if  Xnext(i)>LBUB(i,2)
                Xnext(i)=LBUB(i,2);
            end
            if  Xnext(i)<LBUB(i,1)
                Xnext(i)=LBUB(i,1);
            end
        end
        Ynext=AF_foodconsistence(Xnext);
    else
        [Xnext,Ynext]=AF_prey(Xi,i,visual,step,try_number,LBUB,lastY);
    end
else
    [Xnext,Ynext]=AF_prey(Xi,i,visual,step,try_number,LBUB,lastY);
end