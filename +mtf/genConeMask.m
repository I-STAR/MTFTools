function [msk,r,theta] = genConeMask(sz, centerCoor, dSize, varargin)
% dSize: can be empty --> then no dim3 scale needed

% coneRg: defines the range in elevation (lowest to highest) (included)
% you are essentially getting a ring

  p = inputParser;
  addParameter(p, 'coneRg', [-1 1], @isnumeric);
  addParameter(p, 'rRange', [], @(x) isnumeric(x) || isempty(x));
  addParameter(p, 'bDebug', 0, @isnumeric);
  parse(p, varargin{:});
  p = p.Results;

  [coneRg,rRange,bDebug] = deal(p.coneRg, p.rRange, p.bDebug);

  if isempty(dSize)
    dSize = [1 1 1];
  end

  [x,y,z] = ndgrid(1:sz(1),1:sz(2),1:sz(3));
  x = x - centerCoor(1);
  y = y - centerCoor(2);
  % note that you do not need to handle top and bottom issue here...
  % just remember to scale the =z= properly
  z = (z - centerCoor(3)) * dSize(3)/dSize(1);

  [theta,elevation,r] = cart2sph(x,y,z);


  %%% now it's time to leave a cone here...
  coneRg = deg2rad(coneRg);
  msk = elevation >= coneRg(1) & elevation <= coneRg(2);
  if ~isempty(rRange); msk = logical(msk .* (r <= rRange(2)) .* (r >= rRange(1))); end
  if bDebug; figure, mprov(msk); end
end
