function [out] = isloginum(in)
% True: if input is, True|False|1|0
  if islogical(in) || (isnumeric(in) && isequal(in,1)) || (isnumeric(in) && isequal(in,0))
    out = true;
  else
    out = 0;
  end
end

