function [msk,r,theta] = genAxialMask(sz, centerCoor, dSize, varargin)
% dSize: can be empty --> then no dim3 scale needed
% theta would be from -pi to pi
  p = inputParser;
  addParameter(p, 'sliceRg', 0, @isnumeric);
  addParameter(p, 'rRange', [], @(x) isnumeric(x) || isempty(x));
  addParameter(p, 'bDebug', 0, @isnumeric);
  parse(p, varargin{:});
  p = p.Results;

  [sliceRg,rRange,bDebug] = deal(p.sliceRg, p.rRange, p.bDebug);

  if isempty(dSize)
    dSize = [1 1 1];
  end
  assert(length(sz) == 3)
  

  [x,y,z] = ndgrid(1:sz(1),1:sz(2),1:sz(3));
  x = x - centerCoor(1);
  y = y - centerCoor(2);
  z = (z - centerCoor(3)) * dSize(3)/dSize(1);

  [theta,~,r] = cart2sph(x,y,z);

  nSlice = fix(centerCoor(3));
  msk = zeros(sz, 'logical');
  msk(:,:,nSlice+sliceRg) = true;
  if ~isempty(rRange); msk = logical(msk .* (r <= rRange(2)) .* (r >= rRange(1))); end
  if bDebug; figure, mprov(msk); end
end
