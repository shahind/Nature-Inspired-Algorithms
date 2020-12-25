% This function gives boundaries and dimension of search space for test functions.
function [lb,ub,D]=benchmark_range(func_num)

%If lower bounds of dimensions are the same, then 'lb' is a value.
%Otherwise, 'lb' is a vector that shows the lower bound of each dimension.
%This is also true for upper bounds of dimensions.

%Insert your own boundaries with a new func_num.


if func_num==1
    lb=-100;ub=100;D=30;
end

if func_num==2
    lb=-10;ub=10;D=30;
end

if func_num==3
    lb=-100;ub=100;D=30;
end

if func_num==4
    lb=-100;ub=100;D=30;
end

if func_num==5
    lb=-30;ub=30;D=30;
end

if func_num==6
    lb=-100;ub=100;D=30;
end

if func_num==7
    lb=-1.28;ub=1.28;D=30;
end

if func_num==8
    lb=-500;ub=500;D=30;
end

if func_num==9
    lb=-5.12;ub=5.12;D=30;
end

if func_num==10
    lb=-32;ub=32;D=30;
end

if func_num==11
    lb=-600;ub=600;D=30;
end

if func_num==12
    lb=-50;ub=50;D=30;
end

if func_num==13
    lb=-50;ub=50;D=30;
end

if func_num==14
    lb=-65.536;ub=65.536;D=25;
end

if func_num==15
    lb=-5;ub=5;D=4;
end

if func_num==16
    lb=-5;ub=5;D=2;
end

if func_num==17
    lb=[-5 0];ub=[10 15];D=2;
end

if func_num==18
    lb=-2;ub=2;D=2;
end

if func_num==19
    lb=0;ub=1;D=3;
end

if func_num==20
    lb=0;ub=1;D=6;
end

if func_num==21
    lb=0;ub=10;D=4;
end

if func_num==22
    lb=0;ub=10;D=4;
end

if func_num==23
    lb=0;ub=10;D=4;
end