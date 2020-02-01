function [cBinned, axsBinned] = discretizeCurve(c, axs, nBin, nThrow)
% ARCHIVED!! (replaced with `discretizeCurveMaxFreq`)

% discretize a curve into regular grid (through binning, not interpolation)
% 
% Input: axis, curve, number of bins
%        if `nBin` is negative, use as oversample factor
% output, new axis, new curve
% Note: 
% 1. be careful if you bin size is too small... severe jump may happen @@@TODO detect it...

  if nargin == 3; nThrow = fix(nBin/20); end
  if nBin < 0; nBin = -(nBin*(max(axs)-1)); end

  axsBinned = linspace(1, max(axs), nBin);
  temp = discretize(axs,axsBinned);
  cBinned = accumarray(temp,c,[],@mean)';
  axsBinned = axsBinned(1:end-1);

  axsBinned = axsBinned((nThrow+1):end-nThrow);
  cBinned = cBinned((nThrow+1):end-nThrow);

% Interpolation based method...typically not as good as rebinning method
% axsBinned = linspace(1, max(axs), nBin);
% [axs, uniqueidx] = unique(axs);
% cBinned = interp1(axs,c(uniqueidx),axsBinned);
end