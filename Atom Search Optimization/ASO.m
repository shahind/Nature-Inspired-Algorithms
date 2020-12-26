%--------------------------------------------------------------------------
% Developed in MATLAB R2011b
% W. Zhao, L. Wang and Z. Zhang, Atom search optimization and its 
% application to solve a hydrogeologic parameter estimation problem, 
% Knowledge-Based Systems,2019,163:283-304, https://doi.org/10.1016/j.knosys.2018.08.030.
%--------------------------------------------------------------------------
% Atom Search Optimization.
function [X_Best,Fit_XBest,Functon_Best]=ASO(alpha,beta,Fun_Index,Atom_Num,Max_Iteration)

% Dim: Dimension of search space.
% Atom_Pop: Population (position) of atoms.
% Atom_V:  Velocity of atoms.
% Acc: Acceleration of atoms.
% M: Mass of atoms. 
% Atom_Num: Number of atom population.
% Fitness: Fitness of atoms.
% Max_Iteration: Maximum of iterations.
% X_Best: Best solution (position) found so far. 
% Fit_XBest: Best result corresponding to X_Best. 
% Functon_Best: The fitness over iterations. 
% Low: The low bound of search space.
% Up: The up bound of search space.
% alpha: Depth weight.
% beta: Multiplier weight

   Iteration=1;
   [Low,Up,Dim]=Test_Functions_Range(Fun_Index); 
 
   % Randomly initialize positions and velocities of atoms.
     if size(Up,2)==1
         Atom_Pop=rand(Atom_Num,Dim).*(Up-Low)+Low;
         Atom_V=rand(Atom_Num,Dim).*(Up-Low)+Low;
     end
   
     if size(Up,2)>1
        for i=1:Dim
           Atom_Pop(:,i)=rand(Atom_Num,1).*(Up(i)-Low(i))+Low(i);
           Atom_V(:,i)=rand(Atom_Num,1).*(Up(i)-Low(i))+Low(i);
        end
     end

 % Compute function fitness of atoms.
     for i=1:Atom_Num
       Fitness(i)=Test_Functions(Atom_Pop(i,:),Fun_Index,Dim);
     end
       Functon_Best=zeros(Max_Iteration,1);
       [Max_Fitness,Index]=min(Fitness);
       Functon_Best(1)=Fitness(Index);
       X_Best=Atom_Pop(Index,:);
     
 % Calculate acceleration.
 Atom_Acc=Acceleration(Atom_Pop,Fitness,Iteration,Max_Iteration,Dim,Atom_Num,X_Best,alpha,beta);


 % Iteration
 for Iteration=2:Max_Iteration 
           Functon_Best(Iteration)=Functon_Best(Iteration-1);
           Atom_V=rand(Atom_Num,Dim).*Atom_V+Atom_Acc;
           Atom_Pop=Atom_Pop+Atom_V;     
    
    
         for i=1:Atom_Num
       % Relocate atom out of range.  
           TU= Atom_Pop(i,:)>Up;
           TL= Atom_Pop(i,:)<Low;
           Atom_Pop(i,:)=(Atom_Pop(i,:).*(~(TU+TL)))+((rand(1,Dim).*(Up-Low)+Low).*(TU+TL));
           %Evaluate atom. 
           Fitness(i)=Test_Functions(Atom_Pop(i,:),Fun_Index,Dim);
         end
        [Max_Fitness,Index]=min(Fitness);      
     
        if Max_Fitness<Functon_Best(Iteration)
             Functon_Best(Iteration)=Max_Fitness;
             X_Best=Atom_Pop(Index,:);
          else
            r=fix(rand*Atom_Num)+1;
             Atom_Pop(r,:)=X_Best;
        end
     
      % Calculate acceleration.
       Atom_Acc=Acceleration(Atom_Pop,Fitness,Iteration,Max_Iteration,Dim,Atom_Num,X_Best,alpha,beta);
 end

Fit_XBest=Functon_Best(Iteration); 

