function [ A2comp ] = MinMaxCheck( minimum, maximum, A2comp )
%%
% function [ A2comp ] = MinMaxCheck( minimum, maximum, A2comp )
% A2comp is the array to check
% minimum and maximum are arrays which holds the minimum and maximum value of each element of an array (A2comp) respectively
% output returns the array where all values within the range
% if element of A2comp is less than minimum boundary value then it's changed to minimum boundary value
% if element of A2comp is greater than maximum boundary value then it's changed to maximum boundary value
%
% all array must be same in length
%%
% Copyright (c) 2013, Pramit Biswas
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%     * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%%
if nargin < 3
    error('Missing input parameter(s)!')
end
if (length(minimum(:))==length(maximum(:)) && length(maximum(:))==length(A2comp(:)))
    
    size=length(minimum);
    for l=1:size
        if maximum(l)<minimum(l)
            error('Maximum value must be greater than minimum value !!')
        end
    end
    
    for l=1:size
        if(maximum(l)<A2comp(l)||minimum(l)>A2comp(l))
            if(maximum(l)<A2comp(l))
                A2comp(l)=maximum(l);
            else A2comp(l)=minimum(l);
            end
        end
    end
else
    error('All arrays must be same in length...')
end