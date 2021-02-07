function [msk,r,theta] = genConeMask(sz, centerCoor, dSize, varargin)
% Generate a mask to be used in sphere based ESF/MTF calculation
% sz: xyz dimension
% centerCoor: sphere center coordinate
% dSize: can be empty --> then no element spacing scale needed
% See also `EsfCalc_Sphere`

  p = inputParser;
  % iSlice overwrites coneRg, e.g. 0 (single axial), -1:1 (three axial slices); 
  addParameter(p, 'iSlice', 0, @isnumeric); 
  % coneRg: defines the range in elevation (lowest to highest) (included)
  addParameter(p, 'coneRg', [], @isnumeric);
  addParameter(p, 'thetaRg', [], @isnumeric); % [-pi pi] is the range limit
  addParameter(p, 'rRg', [], @(x) isnumeric(x) || isempty(x));
  addParameter(p, 'bDebug', 0, @isnumeric);
  parse(p, varargin{:});
  p = p.Results;

  [iSlice,coneRg,rRg,thetaRg,bDebug] = deal(p.iSlice,p.coneRg, p.rRg, p.thetaRg, p.bDebug);
  
  if isempty(dSize)
    dSize = [1 1 1];
  end

  [x,y,z] = ndgrid(1:sz(1),1:sz(2),1:sz(3));
  x = x - centerCoor(1);
  y = y - centerCoor(2);
  y = y * dSize(2) / dSize(1);
  % note that you do not need to handle top and bottom issue here...
  % just remember to scale the =z= properly
  z = (z - centerCoor(3)) * dSize(3)/dSize(1);
  
  [theta,elevation,r] = cart2sph(x,y,z);

  %%% now it's time to leave a cone here...
  if ~isempty(p.iSlice)
    msk = zeros(sz, 'logical');
    msk(:,:,fix(centerCoor(3))+iSlice) = true;
  else
    coneRg = deg2rad(coneRg);
    msk = elevation >= coneRg(1) & elevation <= coneRg(2);
  end

  if ~isempty(thetaRg); msk = logical(msk .* (theta <= thetaRg(2)) .* (theta >= thetaRg(1))); end
  if ~isempty(rRg); msk = logical(msk .* (r <= rRg(2)) .* (r >= rRg(1))); end
  if bDebug; figure, mprov(msk); end
end
