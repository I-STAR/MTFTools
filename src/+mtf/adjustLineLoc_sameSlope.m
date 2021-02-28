function [out,p1mean,p2s] = adjustLineLoc_sameSlope(in, varargin)
% Adjust line locations based on 1st order polynomial fitting
% in: line locations, number of lines per plane * number of planes
% Note:
% - Assuming all lines have the same slope
% - Unit does not matter

  p = inputParser;
  % If true, assuming same amount of shift bewtween lines
  addParameter(p, 'bSameShift', 1, @util.isloginum);
  parse(p, varargin{:});
  p = p.Results;

  nPlane = size(in,2);
  p1s = zeros(1, nPlane); 
  p2s = p1s;
  out = zeros(size(in), class(in));


  %%% first round of fitting
  for i = 1:nPlane
    loc = in(:,i);
    lineFit = fit((1:length(loc))', loc, 'poly1');
    [p1s(i), p2s(i)] = deal(lineFit.p1, lineFit.p2);
  end
  p1mean = mean(p1s);


  %%% second round of fitting
  if nPlane > 1
    ft = fittype('n*x + p2','problem','n');
    for i = 1:nPlane
      loc = in(:,i);
      lineFit = fit((1:length(loc))', loc, ft, 'problem', p1mean, 'StartPoint', 0);
      p2s(i) = lineFit.p2;
    end
    if p.bSameShift
      p2mean = mean(p2s);
      p2diff = mean(diff(p2s));
      p2s = 0:p2diff:(p2diff*(length(p2s)-1));
      p2s = p2mean + p2s - mean(p2s);
    end
  end


  %%% adjust line locations
  for i = 1:nPlane
    lineFit = polyval([p1mean, p2s(i)], 1:size(in,1));
    out(:,i) = lineFit';
  end
end

