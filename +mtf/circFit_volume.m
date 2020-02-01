function [cent, radius] = circFit_volume(u)
% used in EsfCalc_SingleCircle
  assert(islogical(u));
  uPeri = bwperim(u);

  idx = find(uPeri); % find points in M
  [xx,yy] = ind2sub(size(uPeri),idx); % sub indices

  [R,XC,YC] = circfit(xx,yy);

  cent = [XC, YC];
  radius = R;
end






