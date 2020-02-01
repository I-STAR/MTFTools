function out = tocol(in)
% To column if possible, otherwise throw error
  assert(isvector(in));
  % even for row vector, this operator will give you column vector
  out = in(:);
end
