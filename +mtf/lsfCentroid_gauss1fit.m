function out = lsfCentroid_gauss1fit(l, varargin)
  % fit a Gaussian
  % Input:   l, vector
  % Output:  out, center location
  %
  % has not been detrended --> do not fit the tail
  % varargin: cell array of fitting parameter
  assert(isvector(l));
  if isrow(l); l = l'; end
 
  f = fit((1:length(l)).',double(l),'gauss1', varargin{:});
  out = f.b1;
  % @@@TODO: success judgement based on statistics?
end