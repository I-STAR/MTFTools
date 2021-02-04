function [out] = array2str(in, delim)

% Syntax: 
%
%   IN:  
%
%   OUT:   
  
  if nargin == 1; delim = '_'; end

  str = num2str(in);
  strs = strsplit(str);
  out = strjoin(strs, delim);
end

