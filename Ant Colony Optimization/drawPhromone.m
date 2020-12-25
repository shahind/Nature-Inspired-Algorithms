

function [ ] = drawPhromone(tau , graph)

maxTau = max(tau(:));
minTau = min(tau(:));

tau_normalized = (tau - minTau) ./ (maxTau - minTau);

for i = 1 : graph.n -1 
    for j = i+1 : graph.n
        x1 = graph.node(i).x;
        y1 = graph.node(i).y;
        
        x2 = graph.node(j).x;
        y2 = graph.node(j).y;
        
        X = [x1 , x2];
        Y = [y1 , y2];
        
         tau(i , j);
 
        plot(X,Y, 'color' , [0, 0, (1-tau_normalized(i,j)),  tau_normalized(i,j)] , 'lineWidth', 10.*tau_normalized(i,j) + 1)
 
    end
end

for i = 1 : graph.n
    hold on
    X = [graph.node(:).x];
    Y = [graph.node(:).y];
    plot(X , Y , 'ok',  'MarkerSize', 10, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', [1 .6 .6])
end


title('All Phromones')
box on

end