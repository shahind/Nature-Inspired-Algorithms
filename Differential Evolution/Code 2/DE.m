clc
clear
Function_name='F1';
[l,u,dim,fun]=Functions(Function_name);
%%Bounds & Parameters
Np=5;
lb = l*ones(1,dim);
ub = u*ones(1,dim);
T=100;
PCr=0.8;
F=0.85;
%%Initialisation
f=NaN(Np,1);                
fu=NaN(Np,1);
D=dim;
U=NaN(Np,D);
%%Initial population
P=repmat(lb,Np,1) +repmat((ub-lb),Np,1).*rand(Np,D);    
%Calculation of initial fitness
for p=1:Np
    f(p) = fun(P(p,:));
end
for t=1:T
    
    for i=1:Np
        
        
        %%Mutation
        Candidates=[1:i-1 i+1:Np];
        idx=Candidates(randperm(Np-1,3));
        
        x1=P(idx(1),:);
        x2=P(idx(2),:);
        x3=P(idx(3),:);
        
        V=x1+F*(x2-x3);
        
        
        %%Crossover(binomial)
        
        del=randi(D,1);
        
        for j=1:D
            
            if(rand<=PCr)||del==j
                U(i,j)=V(j);
            else
                U(i,j)=P(i,j);
            end
        end
    end
    
    
%%Checking Bounds and Greedy Selection   
   for j=1:Np
        U(j,:)=min(ub,U(j,:));
        U(j,:)=max(lb,U(j,:));
        
        fu(j)=fun(U(j,:));
        
        if fu(j)<f(j)
           P(j,:)=U(j,:);
            f(j)=fu(j);
        end
   end
   
   bestfitness(t)=min(f);
   disp(['Iteration ' num2str(t) ': Best Cost = ' num2str(bestfitness(t))]);
   
end
%% Results
figure('Name',Function_name,'NumberTitle','off');
semilogy(bestfitness, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;