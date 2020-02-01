function [output] = idxbynum(in1, num, varargin)
  assert(isnumeric(num));
  output = idxbystr(in1, num2idxstr(num), varargin{:});
end

