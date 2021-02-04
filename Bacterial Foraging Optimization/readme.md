# this is a sub-directory of Nature-Inspired Algorithms repository in order to see the full list of algorithms please go to https://github.com/shahind/Nature-Inspired-Algorithms

# Bacterial Foraging Optimization

Classical Bacterial Foraging Optimization with an application to Rosenbrock function.
The code is made improving the Bacterial Foraging code of Wael Korani,
http://www.mathworks.com/matlabcentral/fileexchange/20217-bacterial-foraging
Based on Section 2.2 of,
Chen, Hanning, Yunlong Zhu, and Kunyuan Hu. "Cooperative bacterial foraging optimization." Discrete Dynamics in Nature and Society 2009 (2009)

Currently the BFO code is programmed to optimize the two-variable Rosenbrock function,
f(x,y) = (a-x)^2 + b*(y-x^2)^2
(rose_fungraph plots a countourplot of the Rosenbrock function)
To optimize other functions it is necessary to change,
fitnessBFO.m


Reference:

https://ch.mathworks.com/matlabcentral/fileexchange/53835-bacterial-foraging-optimization?s_tid=srchtitle
