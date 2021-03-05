function y = w(x, c1, c2)
y = zeros(length(x), 1);
for k = 1 : length(x)
    y(k) = sum(c1 .* cos(c2 .* x(:, k)));
end