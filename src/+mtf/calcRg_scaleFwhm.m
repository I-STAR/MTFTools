function [rg] = calcRg_scaleFwhm(sca, fwhm, cen, l)
% Calculate a range: (-XXX:XXX) + center, XXX is determined by a scaled FWHM value
%   also make sure not out of boundary
% peak (cen) should be centered before running this function
  lMargin = min(cen, fix(sca*fwhm/2));
  rMargin = min(l-cen+1, fix(sca*fwhm/2));
  margin_ = min(lMargin,rMargin);
  rg = (cen - margin_ + 1) : (cen + margin_ - 1);
end