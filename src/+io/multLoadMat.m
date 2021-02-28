function varargout = multLoadMat(filePath, varargin)
% Load multiple variables `varargin` from mat file `filePath`
% See also `io.forceLoadMat`
  assert(ischar(filePath));
  temp = load(filePath, '-mat');
  
  varargout = cell(1, length(varargin));
  for i = 1:length(varargin)
    varargout{i} = temp.(varargin{i});
  end
end
