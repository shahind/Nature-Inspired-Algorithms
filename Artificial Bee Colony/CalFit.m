function fit = CalFit(f)

if f >= 0
    fit  = 1 / (1+f);
else 
    fit = 1 + abs(f);
end