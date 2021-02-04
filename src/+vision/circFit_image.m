function [cent, radius] = circFit_image(u, uSzScale)
  if nargin == 1; uSzScale = [1 1]; end
  assert(islogical(u));
  uPeri = bwperim(u);

  idx = find(uPeri); % find points in M
  [xx,yy] = ind2sub(size(uPeri),idx); % sub indices
  yy = yy * uSzScale(2) / uSzScale(1);

  [R,XC,YC] = vision.circfit(xx,yy);
  % scale back coordinates
  YC = YC * uSzScale(1) / uSzScale(2);

  cent = [XC, YC];
  radius = R;
end






