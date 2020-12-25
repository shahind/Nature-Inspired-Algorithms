function demo2
%DEMO2  Demo for usage of DIFFERENTIALEVOLUTION.
%   DEMO2 starts searching the minimum of Shekel's Foxholes as a demo.
%   Modify this function for your first optimization.
%
%   <a href="differentialevolution.html">differentialevolution.html</a>
%   <a href="https://www.mathworks.com/matlabcentral/fileexchange/18593-differential-evolution">File Exchange</a>
%   <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KAECWD2H7EJFN">Donate via PayPal</a>
%
%   Markus Buehren
%   Last modified 31.08.2014
%
%   See also DIFFERENTIALEVOLUTION, FOXHOLES.

% Set title
optimInfo.title = 'Demo 2 (Shekel''s Foxholes)';

% Specify objective function
objFctHandle = @foxholes;

% Define parameter names, ranges, quantizations and initial values:

% Here: single vector-valued parameter with no name, as function foxholes is
% called with a parameter vector as only input
paramDefCell1 = {'', [-25 65; -65 65], [0; 0], [0; 0]};
paramDefCell2 = {'', [-65 65; -65 65], [0; 0], [0; 0]};

% Note: paramDefCell1 is used in first optimization run, paramDefCell2 
% in continuation using a saved result file. Paraemter range paramDefCell1
% does not contain the optimum parameter set!


% No additional function parameters needed
objFctSettings = {};

% No parameter vector needed
objFctParams = [];

% Get default DE parameters
DEParams = getdefaultparams;

% Set number of population members (often 10*D is suggested; here we use
% more as we know that the Foxholes functions has many local minima).
DEParams.NP = 50;

% Do not use slave processes here. If you want to, set feedSlaveProc to 1 and
% run startmulticoreslave.m in at least one additional Matlab session.
DEParams.feedSlaveProc = 0;

% Set times
DEParams.maxiter  = 20;
DEParams.maxtime  = 30;  % in seconds
DEParams.maxclock = [];

% Set display options
DEParams.infoIterations = 1;
DEParams.infoPeriod     = 10;  % in seconds

% Do not send E-mails
emailParams = [];

% Set random state in order to always use the same population members here
setrandomseed(1);

% Start differential evolution
[bestmem, bestval, bestFctParams, nrOfIterations, resultFileName] = differentialevolution(...
  DEParams, paramDefCell1, objFctHandle, objFctSettings, objFctParams, emailParams, optimInfo); %#ok

disp(' ');
disp('Best parameter set returned by function differentialevolution:');
disp(bestmem);

% Continue optimization by loading result file
if DEParams.saveHistory
  
  disp(' ');
  disp(textwrap2(sprintf(...
    'Now continuing optimization by loading result file %s.', resultFileName)));
  disp(' ');
  
  DEParams.maxiter  = 200;
  DEParams.maxtime  = 90;  % in seconds

  [bestmem, bestval, bestFctParams] = differentialevolution(...
    DEParams, paramDefCell2, objFctHandle, objFctSettings, objFctParams, emailParams, optimInfo, ...
    resultFileName); %#ok
  
  disp(' ');
  disp('Best parameter set returned by function differentialevolution:');
  disp(bestFctParams);
end

