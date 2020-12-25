# this is a sub-directory of Nature-Inspired Algorithms repository in order to see the full list of algorithms please go to https://github.com/shahind/Nature-Inspired-Algorithms

This is simple basic PSO function.
This function is well illustrated and analogically programed to understand and visualize Particle Swarm Optimization theory in better way and how it implemented.
To run this you also need to have a function MinMaxCheck.m(File Id: #43251)
PSO Description: http://en.wikipedia.org/wiki/Particle_swarm_optimization
Program Description:
%%
% INPUT VARIABLES
% Bird_in_swarm=Number of particle=agents=candidate
% Number_of_quality_in_Bird=Number of Variable
%
% MinMaxRange: jx2 matrix; jth row contains minimum and maximum values of the jth variable
% say you have a variable N1
% which can have maximum value M1 and minimum value m1
% then your matrix will be [m1 M1]
% for more:
% [m1 M1; m2 M2; mj Mj]
%
% Food_availability=Objective function with one input variable (for more than one variable you may use array)
% example for two variable
% function f = funfunc(array)
% a=array(1);
% b=array(2);
% f = a+b ;
% end
% Food_availability is a string, for above example : 'funfunc'
%
% availability_type is string 'min' or 'max' to check depending upon need to minimize or maximize the Food_availability
% velocity_clamping_factor (normally 2)
% cognitive_constant=c1=individual learning rate (normally 2)
% social_constant=c2=social parameter (normally 2)
% normally C1+C2>=4
%
% Inertia_weight=At the beginning of the search procedure, diversification is heavily weighted, while intensification is heavily weighted at the end of the search procedure.
% Min_Inertia_weight=min of inertia weight (normally 0.4)
% Max_Inertia_weight=max of inertia weight (normally 0.9)
% max_iteration=how many times readjust the position of the flock/swarm of birds its quest for food
%
%
% OUTPUT VARIABLE
% optimised_parameters : Optimal parameters

Required MATLAB function MinMaxCheck.m (File Id: #43251)
http://www.mathworks.in/matlabcentral/fileexchange/43251-bound-values-of-an-array

If the program helps you in any way in your seminar/project/research/thesis etc. work, then please cite our work (either this page or the paper).

Thank you.

Reference:

Pramit Biswas (2020). Particle Swarm Optimization (PSO) (https://www.mathworks.com/matlabcentral/fileexchange/43541-particle-swarm-optimization-pso), MATLAB Central File Exchange. Retrieved December 25, 2020.

@inproceedings{biswas2014pso, title={PSO based PID controller design for twin rotor MIMO system}, author={Biswas, Pramit and Maiti, Roshni and Kolay, Anirban and Sharma, Kaushik Das and Sarkar, Gautam}, booktitle={IEEE International Conference on Control, Instrumentation, Energy and Communication (CIEC)}, pages={56--60}, year={2014} }

Pramit Biswas, Roshni Maiti, Anirban Kolay, Kaushik Das Sharma, and Gautam Sarkar. "PSO based PID controller design for twin rotor MIMO system," IEEE International Conference on Control, Instrumentation, Energy and Communication (CIEC), pp. 56-60. 2014.