function out = torow(in)
% To row if possible, otherwise throw error
  if ~isempty(in)
    assert(isvector(in));
    out = transpose(in(:));
  else
    out = in;
  end
end
