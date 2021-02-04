function J = fitnessBFO(v)
% v is a vector with two elements
% --------------------
% Rosenbrock function
    a =   1;
    b = 100;
    x = v(1);
    y = v(2);
    J = (a-x)^2 + b*((y-x^2)^2);
end