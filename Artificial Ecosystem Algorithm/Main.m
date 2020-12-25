%--------------------------------------------------------------------------
% SDO code v1.0.
% Developed in MATLAB R2011b
% The code is based on the following papers.
% W. Zhao, L. Wang and Z. Zhang, Artificial ecosystem-based optimization: 
% A novel nature-inspired meta-heuristic algorithm,  Neural Computing and 
% Applications, DOI:10.1007/s00521-019-04452-x.
% --------------------------------------------------------------------------

clc;
clear;
 
MaxIteration=500; 
PopSize=50;
FunIndex=1;
[BestX,BestF,HisBestF]=AEO(FunIndex,MaxIteration,PopSize);


display(['F_index=', num2str(FunIndex)]);
display(['The best fitness is: ', num2str(BestF)]);
%display(['The best solution is: ', num2str(BestX)]);
 if BestF>0
     semilogy(HisBestF,'r','LineWidth',2);
 else
     plot(HisBestF,'r','LineWidth',2);
 end
 xlabel('Iterations');
 ylabel('Fitness');
 title(['F',num2str(FunIndex)]);








