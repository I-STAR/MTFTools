function [out] = array2str(in, delim)
% Convert array to string (similar to `num2str`)  
  if nargin == 1; delim = '_'; end

  str = num2str(in);
  strs = strsplit(str);
  out = strjoin(strs, delim);
end

