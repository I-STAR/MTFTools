function [msk,r,theta] = genAxialMask_2d(sz, centerCoor, varargin)
% In: centerCoor, 1x2, mat convention
  p = inputParser;
  addParameter(p, 'rRange', [], @(x) isnumeric(x) || isempty(x));
  parse(p, varargin{:});
  p = p.Results;

  rRange = p.rRange;
  assert(length(sz) == 2 && length(centerCoor) == 2);

  [x,y] = ndgrid(1:sz(1),1:sz(2));
  x = x - centerCoor(1);
  y = y - centerCoor(2);

  [theta,r] = cart2pol(x,y);
  msk = ones(sz, 'logical');
  if ~isempty(rRange); msk = logical(msk .* (r <= rRange(2)) .* (r >= rRange(1))); end
end
