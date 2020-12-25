function [ tau ] = updatePhromone(tau , colony)
% Update the phromone matrix. 
nodeNo = length (colony.ant(1).tour);
antNo = length( colony.ant(:) );

for i = 1 : antNo % for each ant
    for j = 1 : nodeNo-1 % for each node in the tour
        currentNode = colony.ant(i).tour(j);
        nextNode = colony.ant(i).tour(j+1);
        
        tau(currentNode , nextNode) = tau(currentNode , nextNode)  + 1./ colony.ant(i).fitness;
        tau(nextNode , currentNode) = tau(nextNode , currentNode)  + 1./ colony.ant(i).fitness;

    end
end

end