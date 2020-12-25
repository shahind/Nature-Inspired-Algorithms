function F = Schaffer(x)

x1 = x(1);
x2 = x(2);

fact1 = (sin(x1^2 - x2^2))^2 - 0.5;
fact2 = (1 + 0.001*(x1^2 + x2^2))^2;
F = 0.5 + fact1/fact2;

