function [xn,yn]=findrange(xn,yn,range)
for i=1:length(yn),
if xn(i)<=range(1), xn(i)=range(1); end
if xn(i)>=range(2), xn(i)=range(2); end
if yn(i)<=range(3), yn(i)=range(3); end
if yn(i)>=range(4), yn(i)=range(4); end
end