f = @(xfun,yfun) (1-xfun).^2 + 100*(yfun-xfun.^2).^2;
xfun = linspace(-1.5,1.5); yfun = linspace(-1,3);
[xxfun,yyfun] = meshgrid(xfun,yfun); fffun = f(xxfun,yyfun);
levels = 10:10:300;
LW = 'linewidth'; 
contour(xfun,yfun,fffun,levels,LW,1.2), colorbar
axis([-1.5 1.5 -1 3]), axis square, hold on
    clear ffun fffun levels LW xfun xxfun yfun yyfun