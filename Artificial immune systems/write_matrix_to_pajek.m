function write_matrix_to_pajek(matrix, path, varargin)

% WRITE_MATRIX_TO_PAJEK writes an adjacency matrix representing a graph to 
% Pajek format, which can be read using the Pajek graph visualization tool, 
% as well as the modelGUI application.
% 
% Arguments:
% 
% matrix          A square adjacency matrix
% path            The path specify the Pajek output file
% varargin        Parameters refining the export:
%                       'weighted' [true/false]: whether to use the matrix
%                       values as edge weights (default = true).
%                       'threshold_low': the low threshold at which to
%                       include an edge (default = 0).
%                       'threshold_high': the high threshold at which to
%                       include an edge (default = realmax).
%                       'directed': whether the edges are directed (default 
%                       = true); in this case, the rule is column -> row
%                       'labels': an N x 1 vector of vertex labels
%                       (default = none).
%                       'coords': an N x 3 matrix of vertex coordinates
%                       (default = none).
% 
% Author: Andrew Reid, BIC, MNI, 2011
%

p.weighted=true;
p.threshold_low=0;
p.threshold_high=realmax;
p.directed=true;
p.labels={};
p.coords={};

validParams     = {     ...
  'weighted',          ...
  'threshold_low',            ...
  'threshold_high',       ...
  'directed',      ...
  'labels',      ...
  'coords',      ...
  };

if nargin > 2
  if mod( numel( varargin ), 2 ) ~= 0
    error( 'write_matrix_to_pajek:InvalidInput', ['All input parameters after the fileName must be in the ' ...
      'form of param-value pairs'] );
  end
  params  = lower( varargin(1:2:end) );
  values  = varargin(2:2:end);

  if ~all( cellfun( @ischar, params ) )
    error( 'write_matrix_to_pajek:InvalidInput', ['All input parameters after the fileName must be in the ' ...
      'form of param-value pairs'] );
  end

  lcValidParams   = lower( validParams );
  for ii =  1 : numel( params )
    result        = strmatch( params{ii}, lcValidParams );
    % If unknown param is entered ignore it
    if isempty( result )
      continue
    end
    % If we have multiple matches make sure we don't have a single unambiguous match before throwing
    % an error
    if numel( result ) > 1
      exresult    = strmatch( params{ii}, validParams, 'exact' );
      if ~isempty( exresult )
        result    = exresult;
      else
        % We have multiple possible matches, prompt user to provide an unambiguous match
        error( 'write_matrix_to_pajek:InvalidInput', 'Cannot find unambiguous match for parameter ''%s''', ...
          varargin{ii*2-1} );
      end
    end
    result      = validParams{result};
    p.(result)  = values{ii};
  end
end

[fid, msg] = fopen(path, 'w');

if fid < 0
    error('write_matrix_to_pajek:InvalidPath', 'Could not open %s for writing: %s', path, msg);
end


if size(matrix,1)~=size(matrix,2)
   error('write_matrix_to_pajek:InavlidMatrix', 'Matrix must be square.');
end

N=size(matrix,1);

% Write vertices
fprintf(fid,'*vertices %i', N);
for i = 1 : N
   
    fprintf(fid, '\n %i', i);
    if (~isempty(p.labels))
        fprintf(fid, ' "%s"', char(p.labels(i)));
    else
        fprintf(fid, ' "%i"', i);
    end
    if (~isempty(p.coords))
        fprintf(fid, ' %f %f %f', p.coords(i,1), p.coords(i,2), p.coords(i,3));
    end
   
end

% Write edges
if p.directed == true
    fprintf(fid,'\n*arcs');
else
    fprintf(fid,'\n*edges');
end

for i = 1 : N
    start = 1;
    if (p.directed ~= true)
        start = i;
    end
    for j = start : N
        if (i ~= j)
            value = matrix(i,j);
            if value > p.threshold_low && value < p.threshold_high
                fprintf(fid, '\n %i %i', i, j);
                if p.weighted == true
                    fprintf(fid, ' %f', 1/value);
                end
            end
        end
    end
end

fclose(fid);
