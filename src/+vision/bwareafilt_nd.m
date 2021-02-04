function [out] = bwareafilt_nd(in, k)
% Extension of builtin `bwareafilt` to nD (n-dimension)
  if nargin == 0; k = 1; end
  assert(islogical(in), 'Error. Logical input needed');
  CC = bwconncomp(in, 26);
  numPixels = cellfun(@numel,CC.PixelIdxList);
  [~,idx] = maxk(numPixels, k);
  
  %%% currently only handles k = 1 case
  assert(k == 1);
  out = false(size(in));
  out(CC.PixelIdxList{idx}) = true;
end
