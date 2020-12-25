function F = Griewank(x)
d = sqrt(1:length(x));
F = 1+((1/4000)*sum((x).^2)) - prod(cos(x./d.^0.5));