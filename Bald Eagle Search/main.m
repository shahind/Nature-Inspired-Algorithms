clc;
clear;
number_fun='F5';
MaxIt=1000;
nPop=80;
[low,high,dim,fun] = Get_Functions_details(number_fun);
[value,fun_hist]=BES(nPop,MaxIt,low,high,dim,fun);
plot(fun_hist,'-','Linewidth',1.5)
xlabel('Iteration')
ylabel('fitness')
legend('BES')