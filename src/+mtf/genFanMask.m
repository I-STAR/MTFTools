function [msk,r,theta] = genFanMask(sz, centerCoor, dSize, varargin)
% dSize: can be empty --> then no dSize scale needed
  p = inputParser;
  addParameter(p, 'thetaRg', [], @isnumeric); % [-pi pi] is the range limit
  addParameter(p, 'rRg', [], @(x) isnumeric(x) || isempty(x));
  addParameter(p, 'bDebug', 0, @isnumeric);
  parse(p, varargin{:});
  p = p.Results;
  [rRg,thetaRg,bDebug] = deal(p.rRg, p.thetaRg, p.bDebug);
  % assert(isempty(dSize) || dSize(1) == dSize(2));
  if isempty(dSize); dSize = [1 1]; end

  [x,y] = ndgrid(1:sz(1),1:sz(2));
  x = x - centerCoor(1);
  y = y - centerCoor(2);
  y = y * dSize(2) / dSize(1);
  
  [theta,r] = cart2pol(x,y); % `r` should actually be called `rho (but to be consistent with `cone` version)

  %%% fan mask generation
  msk = ones([sz(1) sz(2)], 'logical');
  if ~isempty(thetaRg); msk = logical(msk .* (theta <= thetaRg(2)) .* (theta >= thetaRg(1))); end
  if ~isempty(rRg); msk = logical(msk .* (r <= rRg(2)) .* (r >= rRg(1))); end
  
  %%% debug
  if bDebug; figure, imshow(msk, []); end
end
