function [ G ] = get_random_graph( N, K )
%GET_RANDOM_GRAPH Constructs a random binary graph with N vertices and K 
%                  edges per vertex (on average). This translates to a
%                  connection probability of p = K / N.
%   

if N < 2
    error('N must be at least 2');
end

if K < 1
    error('K must be at least 1');
end

G = zeros(N);

% For each vertex, connect its K closest neighbours

p = K / N;

for i = 1 : N
   count = 0;
   for j = i + 1 : N
       if rand < p
           G(i,j) = 1;
           G(j,i) = 1;
           count = count + 1;
       end
   end
   if count == 0
      % ensure at least one edge
      j = round(rand * N);
      while (j < 1 || j == i || j > N)
          j = round(rand * N);
      end
      G(i,j) = 1;
      G(j,i) = 1;
   end
end



