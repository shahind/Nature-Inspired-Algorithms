function [Xnext,Ynext]=AF_follow(X,i,visual,step,deta,try_number,LBUB,lastY)
% ׷β��Ϊ
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
    XX=X(:,index);
    YY=lastY(index);
    [Ymax,Max_index]=max(YY);
    Xmax=XX(:,Max_index);
    Yi=lastY(i);
    if Ymax/nf>deta*Yi;
        Xnext=Xi+rand*step*(Xmax-Xi)/norm(Xmax-Xi);
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
        [Xnext,Ynext]=AF_prey(X(:,i),i,visual,step,try_number,LBUB,lastY);
    end
else
    [Xnext,Ynext]=AF_prey(X(:,i),i,visual,step,try_number,LBUB,lastY);
end