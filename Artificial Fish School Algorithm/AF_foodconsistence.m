function [Y]=AF_foodconsistence(X)
fishnum=size(X,2);
for i=1:fishnum
    x = X(1,i); y = X(2,i);
    Y(1,i) = 3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ...
   - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ...
   - 1/3*exp(-(x+1).^2 - y.^2);
end
