function [nvStruct] = getNVStruct(varargin)
% Get name value structure (suitable for `InputParser`)
  if isempty(varargin) || (length(varargin) == 1 && isempty(varargin{1}))
    % i.e. getNVStruct() or getNVStruct([])
    % empty structure is allowed for `inputParser`
    nvStruct = struct; 
  elseif isstruct(varargin{1})
    assert(isscalar(varargin{1})); % structure array would be weird for `inputParser`
    nvStruct = varargin{1};
  elseif ischar(varargin{1})
    % nv pair (but not expanded)
    nvStruct = util.struct_scalar(varargin{:});
  elseif length(varargin) == 2 && iscell(varargin{1}) && iscell(varargin{2})
    nvStruct = nvcell2struct(varargin{1}, varargin{2});
  elseif length(varargin) == 1 && ischar(varargin{1}{1})
    % nv pair (but not expanded)
    nvStruct = util.struct_scalar(varargin{:}{:});
  else
    error('Error. Unsupported input format');
  end
end

function [sOut] = nvcell2struct(names, values)
  sOut = struct;
  for i = 1:length(names)
    sOut.(names{i}) = values{i};
  end
end

