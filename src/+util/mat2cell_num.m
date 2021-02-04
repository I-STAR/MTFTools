function [out] = mat2cell_num(in, nCel)
% Similar to `mat2cell`, but providing "number of bins" instead of "bin sizes". 
  assert(ndims(in) == length(nCel));
  pD = cell(1, length(nCel));
  for i = 1:length(nCel)
    pD{i} = kernel_divide(size(in,i), nCel(i));
  end
  out = mat2cell(in, pD{:});
end

function [out] = kernel_divide(sz, in)
  out = repmat(floor(sz/in), [1 in-1]);
  if sum(out) ~= sz; out = [out -sum(out)+sz]; end
end


