clear all; clc;
tic
x_min = -32;
x_max = 32;
Dim = 10;
RUN = 1;
for run=1:RUN
% Initial Conditions:
%%%%%%%%%%%%%%%%%%%%%
Total_Journey_Steps = 1000;
Camel_Caravan = 50;
Visibility = 0.1;
Tmin = 30;
Tmax = 60;
% Iteration Initialization:
%%%%%%%%%%%%%%%%%%%%%%%%%%%
best_iter = 1;
x_old = (x_max-x_min)*rand(Camel_Caravan,Dim)+x_min;
[Fit,x_best,ind] = Fitness_multi(x_old); % Fitness Function
Fit_old = Fit(1);
old_best = x_best;
x_old = x_old(ind,:);
v = rand(Camel_Caravan,1);

% Parameters Equations:
%%%%%%%%%%%%%%%%%%%%%%%
for i=1:Total_Journey_Steps
    T = unifrnd(Tmin,Tmax,Camel_Caravan,Dim);
    End = 1-(T-Tmin)/(Tmax-Tmin);
    for j=1:Camel_Caravan
        if v(j)>Visibility
            x(j,:) = x_old(j,:)+End(j,:).*(old_best-x_old(j,:));  % Updating equation
        else
            x(j,:) = (x_max-x_min)*rand(1,Dim)+x_min;
        end
    end
    [Fit,x_best,ind] = Fitness_multi(x);  % Fitness function after the update
    
    if Fit(1)<Fit_old   % Condition to evaluate the iteration corresponding to the best solution
        best_iter = i;
        old_best = x_best;
        Fit_old = Fit(1);
    end
    
    x_old = x;
    v = rand(Camel_Caravan,1);
end

% iter = 1:Total_Journey_Steps;
% figure(1)
% subplot(3,1,1)
% plot(iter,Temp); grid on;
% subplot(3,1,2)
% plot(iter,Supply); grid on;
% subplot(3,1,3)
% plot(iter,Endurance); grid on;
Best_Iter = best_iter;
X_best = x_best;
Fit_opt(run) = Fit_old;
end
Best_Cost = Fit_opt'
toc