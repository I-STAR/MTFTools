function [gh] = drawcirc_scaler(coor, r, varargin)
  p = inputParser;
  addParameter(p, 'handle', [], @isgraphics);
  addParameter(p, 'nPoints', 100, @isnumeric);
  addParameter(p, 'pDraw', {}, @iscell);
  % This would scale r calculation (but would not scale coor)
  addParameter(p, 'dSize', [1 1], @isnumeric)
    
  parse(p, varargin{:});
  p = p.Results;

  coor = fliplr(coor);
  assert(length(coor) == 2);
  
  if ~isempty(p.handle)
    figure(p.handle);
  end
  
  t = linspace(0,2*pi,p.nPoints);
  X = r*cos(t)*p.dSize(1)/p.dSize(2) + coor(1);
  Y = r*sin(t) + coor(2);

  if isempty(p.pDraw)
    gh = line(X,Y);
  else
    gh = line(X,Y,p.pDraw{:});
  end
end