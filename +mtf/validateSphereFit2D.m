function [] = validateSphereFit2D(u, cent, radius, nSlice, uSzScale)
  if nargin == 3; nSlice = 10; uSzScale = [1 1 1]; end
  if nargin == 4; uSzScale = [1 1 1]; end
  
  % slice determine should not scale (since size of u does not scale)
  % but cent(3) should be scaled during r calculation
  figure; 
  iSlices = fix(linspace(cent(3) - radius, cent(3) + radius, nSlice));
  iSlices(~(iSlices > 1 & iSlices < size(u,3))) = [];
  
  nSlice = length(iSlices);
  Nw = ceil(sqrt(nSlice));
  Nh = ceil(nSlice / Nw);
  [ha, ~] = tight_subplot(Nh, Nw, [0 0], [0 0], [0 0]);
  for i = 1:nSlice
    axes(ha(i)); %#ok
    imshow(u(:,:,iSlices(i)), []); hold on;
    rDraw = sqrt(radius^2 - ((cent(3) - iSlices(i)) * uSzScale(3)/uSzScale(1) )^2);
    if isreal(rDraw)
      drawcirc([cent(2) cent(1)], rDraw, 'pDraw', {'LineWidth', 0.5});
    end
  end
end