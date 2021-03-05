

function z=Function(x)
[ps,D]=size(x);
Di=D;
%% %--------------------------------weierstrass(x)Function[-0.5, 0.5]D

% x = x + 0.5;
% a = 0.5;
% b = 3;
% kmax = 20;
% c1(1 : kmax + 1) = a .^ (0 : kmax);
% c2(1 : kmax + 1) = 2 * pi * b .^ (0 : kmax);
% z = 0;
% c = -w(0.5, c1, c2);
% for i = 1 : D
%     z = z + w(x(:, i)', c1, c2);
% end
% z = z + c * D;
%%%%Rastrign's Function [-5.12, 5.12]D

%      z= sum(x .^ 2 - 10 .* cos(2 .* pi .* x) + 10, 2);
%%%%%%%%%%%%%%%Schwefel_1_2Function[-100, 100]D

z = 0;
for i = 1 : D
    z = (z + sum(x(:, 1 : i), 2).^2);
end

 end

