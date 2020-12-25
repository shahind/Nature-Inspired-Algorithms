% "AEFA: Artificial electric field algorithm for global optimization." Swarm and Evolutionary Computation 48, pp. 93-108 (2019). 
% Anupam Yadav 14.04.2018, Department of Mathematics, NIT Jalandhar
% anupuam@gmail.com
clear all;
clc;
for i=1:1
rng('default');
rng(1);
 N=50; 
 max_it=1000; 
 FCheck=1; R=1;
 tag=1; % 1: minimization, 0: maximization
 rand('seed', sum(100*clock));
 func_num=i
 [Fbest,Lbest,BestValues,MeanValues]=AEFA(func_num,N,max_it,FCheck,tag,R);Fbest,
%  semilogy(BestValues,'--r');
%  title(['\fontsize{12}\bf F',num2str(func_num)]);
%  xlabel('\fontsize{12}\bf Iteration');ylabel('\fontsize{12}\bf Best-so-far');
%  legend('\fontsize{10}\bf AEFA',1);
end