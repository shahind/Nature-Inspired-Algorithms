function F = Rosenbrock(x)
d = length(x);
f = NaN(d-1,1);
for i = 1: d-1
    f(i) = 100*(x(i)^2 - x(i+1))^2 + (1 - x(i))^2;
end
F =  sum(f);
