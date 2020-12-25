%% The sorting of nondomninated solutions from a population of 2*npop     %
%% (New solutions+old population) to form a population of npop solutions  %
%% ---------------------------------------------------------------------- %
% Though this sorting function is used for the Bat Algorithm (BA), GA, 
% Cuckoo Search (CS), and Flower Pollination Algorithm (FPA), the sorting
% process is independent of the algorithm used because it is the sorting
% to organize the non-dominated solutions. The main sorting part is based 
% on the standard technique of Non-Dominated Sorting Genetic Algorithms 
% (NSGA-II) by K. Deb et al. (2002) and A. Seshadri (2009). The structure 
% of some parts of this code was based on the code by A. Seshadri (2009). 
% The detailed references are:
% (1) Deb, K. et al.(2002). A Fast Elitist Multiobjective Genetic Algorithm: 
%     NSGA-II, IEEE Trans. Evolut. Comp., vol. 6, no. 2, 182 - 197 (2002).
% (2) Seshadri, A. (2009). NSGA-II: A multi-objective optimization
%     algorithm, Matlab codes @Mathswork, (2009).
% (3) Yang, X.S. (2011). Bat algorithm for multi-objective optimisaiton, 
%     Int. J. of Bio-Inspired Computation, vol. 3, no. 4, 267-274 (2011).
% (4) Yang, X.S. and Deb, S., Multiobjective cuckoo search for design
%     optimization, Computers & Operations Research, vol. 40, no. 6,
%     1616-1624 (2013). 
% (5) Yang, X.S., Karamanoglu, M., He, X., Flower pollination algorithm: 
%     a novel approach for multiobjective optimizaiton, 
%     Engineering Optimization, vol. 46, no. 9, 1222-1237 (2014). 
%% ---------------------------------------------------------------------- %
% Updated and last modifications by X. S. Yang, Sept 2015                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sorted_x = solutions_sorting(x, m, ndim)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inputs and outputs are the extended solutions x with a dimension of    %
%% npop by (ndim+m+2). The objective values are already included in x.    %
% More specifically, the first ndim columns are the actual solutions or 
% variable values (1:ndim), followed by the m columns of objective values. 
% Then, the next column (i.e.,ndim+m+1) corresponds to the ranks, whereas 
% the final column (i.e., ndim+m+2) records the crowd distances. 
% ----------------------------------------------------------------------- %

%% Get the parameters from the inputs such as the size of input population
npop=size(x,1);    % Population size
frontRank=1;       % Pareto frontRank (counter) initialization
Rcol=ndim+m+1;     % Store the ranks in the column Rcol=ndim+m+1
% Define the Parato Front as a class (PF) and initilization of xSol
PF(frontRank).R=[];   xSol=[];
%% The main non-dominated sorting starts here             %%%%%%%%%%%%%%%%% 
for i = 1:npop, 
    % Set the number (initially, 0) of solutions dominating this solution
    xSol(i).n=0;
    % Find all the solutions (that dominated by this solution)
    xSol(i).q=[];
    % Sorting into 3 categories: better (minimization), equal & otherwise
    for j=1:npop,
        % Definte 3 counters for 3 categories
        ns_categ_1=0; ns_categ_2=0; ns_categ_3=0;
        for k=1:m,  % for all m objectives
            % Update the counters for 3 different categories
            if (x(i,ndim+k) < x(j,ndim+k)),      % better/non-dominated
                ns_categ_1=ns_categ_1+1;
            elseif (x(i,ndim+k)==x(j,ndim+k)),   % equal
                ns_categ_2=ns_categ_2+1;
            else                                 % dominated
                ns_categ_3=ns_categ_3+1;
            end
        end % end of k
        % Update the solutions in their class
        if ns_categ_1==0 && ns_categ_2 ~= m
            xSol(i).n=xSol(i).n+1;
        elseif ns_categ_3 == 0 && ns_categ_2 ~= m
            xSol(i).q=[xSol(i).q j];
        end
    end % end of j   
    %% Record/Udpate the Pareto Front
    if xSol(i).n==0, 
        x(i,Rcol)=1;   % Update the Rank #1 (i.e., the Pareto Front)
        PF(frontRank).R = [PF(frontRank).R i];
    end
end % end of i=1:npop (The first round full rank-sorting process)

% Update the rest frontRanks (close, but not on the Pareto Front)
while ~isempty(PF(frontRank).R),
    nonPF=[];    % Intialization the set
    N=length(PF(frontRank).R);
for i=1 :N, 
   % Get the solution/list 
   Sol_tmp_q=xSol(PF(frontRank).R(i)).q; 
   % If not empty, update 
   if ~isempty(xSol(Sol_tmp_q))
       for j = 1:length(Sol_tmp_q),
         % Get the solutions dominated by the current solution    
          Sol_tmp_qj=xSol(PF(frontRank).R(i)).q(j);   
          xSol(Sol_tmp_qj).n=xSol(Sol_tmp_qj).n-1;
          if xSol(Sol_tmp_qj).n==0
             x(Sol_tmp_qj, Rcol)=frontRank + 1;
             nonPF = [nonPF Sol_tmp_qj];
          end
       end % end of j
   end
end  % end of i
   frontRank=frontRank+1;
   PF(frontRank).R=nonPF;
end % end of PF(frontRank)

% Now carry out the sorting of ranks and then update 
[~,frontRanks_Index]=sort(x(:, Rcol));
Sorted_frontRank=x(frontRanks_Index,:); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evaluate the crowding distances for each solution for each frontRank   %
% That is, all the non-domonated solutions on the Pareto Front.  %%%%%%%%%%
Qi=0;      % Initialize a counter
for frontRank=1:(length(PF)-1), 
    % Define/initialize a generalized distance matrix 
    dc = [];    past_Q=Qi+1;
    for i=1:length(PF(frontRank).R),
        dc(i,:)=Sorted_frontRank(Qi+i,:);
    end
    Qi=Qi+i;
    % Solutions are sorted according to their fitness/objective values
    fobj_sorted=[];
    for i=1:m, 
        [~, f_Rank]=sort(dc(:,ndim+i));
        fobj_sorted=dc(f_Rank,:);
        % Find the max and min of the fobj values   
        fobj_max=fobj_sorted(length(f_Rank), ndim+i);
        fobj_min=fobj_sorted(1, ndim+i);
        % Calculate the range of the fobj
        f_range=fobj_max-fobj_min;
        % If the solution is at the end/edge, set its distance as infinity
        dc(f_Rank(length(f_Rank)), Rcol+i)=Inf;
        dc(f_Rank(1), Rcol+i) = Inf;
        for j=2:length(f_Rank)-1, 
            fobj2=fobj_sorted(j+1,ndim + i);
            fobj1=fobj_sorted(j-1,ndim + i);  
            % Check the range or special cases
            if (f_range==0),
                dc(f_Rank(j), Rcol+i)=Inf;
            else
            % Scale the range for distance normalization     
            dc(f_Rank(j),Rcol+i)=(fobj2-fobj1)/f_range;
            end
        end % end of j
    end % end of i
    
    % Calculate and update the crowding distances on the Pareto Front
    dist = []; dist(:,1)=zeros(length(PF(frontRank).R),1);
    for i=1:m, 
        dist(:,1)=dist(:,1)+dc(:, Rcol+i);
    end
    % Store the crowding distrance (dc) in the column of Rcol+1=ndim+m+2
    dc(:, Rcol+1)=dist;  dc=dc(:,1:Rcol+1);
    % Update for the output
    xy(past_Q:Qi,:)=dc;  
end  % end of all ranks search/update
sorted_x=xy();    % Output the sorted solutions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of non-dominated sorting %%%%%%%%%%%%%%
