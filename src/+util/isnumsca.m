function b = isnumsca(in)
% Predicate: is numeric and scalar
  b = isnumeric(in) && isscalar(in);
end
