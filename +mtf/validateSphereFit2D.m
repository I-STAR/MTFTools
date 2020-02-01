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

function [gh] = drawcirc(coor, r, varargin)
  p = inputParser;
  addParameter(p, 'handle', [], @isgraphics);
  addParameter(p, 'nPoints', 100, @isnumeric);
  addParameter(p, 'pDraw', {[]}, @iscell);
    
  parse(p, varargin{:});
  p = p.Results;
  
  if ~isempty(p.handle)
    figure(p.handle);
  end
  
  t = linspace(0,2*pi,p.nPoints);
  X = r*cos(t)+coor(1);
  Y = r*sin(t)+coor(2);
  if isempty_cell(p.pDraw)
    gh = line(X,Y);
  else
    gh = line(X,Y,p.pDraw{:});
  end
end
