function [cv, axs] = oversampleCurves(cv, locs)
% Oversample a curve (e.g. lsf, esf) based on multiple realizations at different locations (phases)
%
%   IN:  cv, along dim-1: one realization of curve, all other dimensions will be considered as multiple realizations
%        locs, 1d vector (row or column) (locations) (: operation will be used for multi-dim input)
%   OUT: curve and then axis
  if nargin == 2; ang = 0; end
  if ang > 45
    warning('Warning. Are you sure this is the right direction (perpendicular?)?');
  end
  cv = reshape(cv, size(cv,1), []);
  locs = locs(:);
  assert(size(cv,2) == length(locs));
  
  axBase = 1:size(cv,1);
  base_loc = max(locs);
  axs = zeros(size(cv));

  for i = 1:length(locs)
    axs(:,i) = axBase - (locs(i) - base_loc);
  end
  axs = axs(:);
  cv = cv(:);
end
