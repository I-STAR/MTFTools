function b = isnumsca(in)
% is numeric and scalar
  b = isnumeric(in) && isscalar(in);
end
