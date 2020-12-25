function [ nextNode ] = rouletteWheel( P )
% Roulette wheel to choose one edge based on P values 
cumsumP = cumsum(P);

r = rand();

nextNode = find( r <= cumsumP );

nextNode = nextNode(1);


end