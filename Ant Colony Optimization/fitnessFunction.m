function [ fitness ] = fitnessFunction ( tour , graph)


fitness = 0;

for i = 1 : length(tour) -1
    
    currentNode = tour(i);
    nextNode = tour(i+1);
    
    fitness = fitness + graph.edges( currentNode ,  nextNode );
    
end


end