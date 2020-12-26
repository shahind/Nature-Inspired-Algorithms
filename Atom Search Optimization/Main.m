%--------------------------------------------------------------------------
% Developed in MATLAB R2011b
% W. Zhao, L. Wang and Z. Zhang, Atom search optimization and its 
% application to solve a hydrogeologic parameter estimation problem, 
% Knowledge-Based Systems,2019,163:283-304, https://doi.org/10.1016/j.knosys.2018.08.030.
%--------------------------------------------------------------------------
 
%%%%%%%%%%%%%%%% Atom Search Optimization (ASO) Algorithm %%%%%%%%%%%%%%%%

% Main function for using ASO algorithm.
 
%Inputs:
% Atom_Num:Number of atoms.
% Max_Iteration: Maximum number of iterations.
%Fun_Index: The index of the test function. 
     
%Outputs:
%X_Best: Best solution (position) found so far. 
% Fit_XBest: Best result corresponding to X_Best. 
% Functon_Fitness: The fitness over iterations.
 
 clc;
clear;
 
Atom_Num=50;
Max_Iteration=1000;
alpha=50;
beta=0.2;
Fun_Index=1;
[X_Best,Fit_XBest,His_Fit]=ASO(alpha,beta,Fun_Index,Atom_Num,Max_Iteration);

display(['F_index=', num2str(Fun_Index)]);
display(['The best fitness is: ', num2str(Fit_XBest)]);
 if Fit_XBest>0
     semilogy(His_Fit,'r','LineWidth',2);
 else
     plot(His_Fit,'r','LineWidth',2);
 end
 xlabel('Iterations');
 ylabel('Fitness');
 title(['F',num2str(Fun_Index)]);

 
 
 
 
 
 
 
 
 
 
 
 
 
 
