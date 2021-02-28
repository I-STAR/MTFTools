function [output] = isdint(input)
% Predicate: is double integer or integer, like the normal 20 or 20.0000 (or 20.0)
  if isinteger(input)
    output = true;
  elseif int32(input) == input
    output = true;
  else
    output = false;
  end
end

