function MatingPool = TournamentSelection(f,Np)
% Tournament selection: Allows each solution to partcipate exactly twice

MatingPool = NaN(Np,1);                     % Vector to store the index of parent solutions
indx = randperm(Np);                        % Randomly shuffling the index of population members

for i = 1 : Np-1                            % Poolsize is Np
    Candidate = [ indx(i) indx(i+1)];       % Selecting one pair of population member for tournament
    CandidateObj = f(Candidate);
    [~, ind] = min(CandidateObj);           % Selecting winner based on minimum fitness value
    MatingPool(i) = Candidate(ind);         % Storing the index of the winner
end

% Tournament selection between the last and the first member
Candidate = [ indx(Np) indx(1)];            
CandidateObj = f(Candidate);
[~, ind] = min(CandidateObj);
MatingPool(Np) = Candidate(ind);
