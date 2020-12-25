function f=benchmark_func(x,func_num)
global initial_flag
persistent fhd f_bias


    if     func_num==1  fhd=str2func('func01'); 
    end


f=feval(fhd, x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Unimodal%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%
    function fit = func01(x)
        global initial_flag
        if (initial_flag == 0)
            initial_flag = 1;
        end
        fit = sum(x.*x, 2);  