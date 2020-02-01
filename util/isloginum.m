function [out] = isloginum(in)

% Syntax: 
%
%   IN:  
%
%   OUT:   

  if islogical(in)
    out = 1;
  elseif (isnumeric(in) && in == 1) || (isnumeric(in) && in == 0)
    out = 1;
  else
    out = 0;
  end
end

