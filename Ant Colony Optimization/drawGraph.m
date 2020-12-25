function [   ]  = drawGraph( graph )
% To visualize the nodes and edges of the graph
hold on 

for i = 1 : graph.n - 1
    for j =  i+1 : graph.n
    
        x1 = graph.node(i).x;
        y1 = graph.node(i).y;
        
        x2 = graph.node(j).x;
        y2 = graph.node(j).y;
        
        X = [x1 , x2]; 
        Y = [y1 , y2];
        
        plot( X , Y , '-k');
    end
end

for i = 1 : graph.n
    X = [graph.node(:).x];
    Y = [graph.node(:).y ];
    plot(X,Y, 'ok', 'MarkerSize', 10, 'MarkerEdgeColor' , 'r' , 'MarkerFaceColor' , [ 1, 0.6 , 0.6]);
end

title ('Al nodes and edges')
box('on')

end