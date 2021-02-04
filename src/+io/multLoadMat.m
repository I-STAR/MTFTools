function varargout = multLoadMat(filePath, varargin)
% Similar to `io.forceLoadMat`, but allows multiple saved variables (varargin)
% See also `io.forceLoadMat`
  assert(ischar(filePath));
  temp = load(filePath, '-mat');
  
  varargout = cell(1, length(varargin));
  for i = 1:length(varargin)
    varargout{i} = temp.(varargin{i});
  end
end
