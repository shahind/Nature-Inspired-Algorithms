%--------------------------------------------------------------------------
% Developed in MATLAB R2011b
% W. Zhao, L. Wang and Z. Zhang, Atom search optimization and its 
% application to solve a hydrogeologic parameter estimation problem, 
% Knowledge-Based Systems,2019,163:283-304, https://doi.org/10.1016/j.knosys.2018.08.030.
%--------------------------------------------------------------------------

function Acc=Acceleration(Atom_Pop,Fitness,Iteration,Max_Iteration,Dim,Atom_Num,X_Best,alpha,beta)
%Calculate mass 
  M=exp(-(Fitness-max(Fitness))./(max(Fitness)-min(Fitness)));
  M=M./sum(M);  
  
 
    G=exp(-20*Iteration/Max_Iteration); 
    Kbest=Atom_Num-(Atom_Num-2)*(Iteration/Max_Iteration)^0.5;
    Kbest=floor(Kbest)+1;
    [Des_M Index_M]=sort(M,'descend');
 
 for i=1:Atom_Num       
     E(i,:)=zeros(1,Dim);   
   MK(1,:)=sum(Atom_Pop(Index_M(1:Kbest),:),1)/Kbest;
   Distance=norm(Atom_Pop(i,:)-MK(1,:));   
     for k=1:Kbest
                  j=Index_M(k);       
                   %Calculate LJ-potential
                  Potential=LJPotential(Atom_Pop(i,:),Atom_Pop(j,:),Iteration,Max_Iteration,Distance);                   
                  E(i,:)=E(i,:)+rand(1,Dim)*Potential.*((Atom_Pop(j,:)-Atom_Pop(i,:))/(norm(Atom_Pop(i,:)-Atom_Pop(j,:))+eps));             
     end

        E(i,:)=alpha*E(i,:)+beta*(X_Best-Atom_Pop(i,:));
        %Calculate acceleration
     a(i,:)=E(i,:)./M(i); 
 end
Acc=a.*G;