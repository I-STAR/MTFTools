function varargout = multLoadMat(filePath, varargin)
  assert(ischar(filePath));
  temp = load(filePath);
  
  varargout = cell(1, length(varargin));
  for i = 1:length(varargin)
    varargout{i} = temp.(varargin{i});
  end
end
