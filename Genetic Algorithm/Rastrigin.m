function F = Rastrigin(x)
F = sum((x.^2 - 10.*cos(2.*pi.*x) + 10));