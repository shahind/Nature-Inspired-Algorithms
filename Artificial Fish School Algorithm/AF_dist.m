function D=AF_dist(Xi,X)
%�����i�������������λ�ã���������
%���룺
%Xi   ��i����ĵ�ǰλ��  
%X    ������ĵ�ǰλ��
% �����
%D    ��i������������ľ���
col=size(X,2);
D=zeros(1,col);
for j=1:col
    D(j)=norm(Xi-X(:,j));
end
