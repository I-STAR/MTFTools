function [cBinned, axsBinned] = discretizeCurveMaxFreq(c, axs, maxFreq, nThrow)
% discretize a curve into regular grid (through binning, not interpolation) (based on maxFreq input)
% 
% Input: axis, curve, max Freq, # points to throw
% output, new axis, new curve

  nBin = (maxFreq*(max(axs)-1));
  if nargin == 3; nThrow = fix(nBin/20); end

  axsBinned = linspace(1, max(axs), nBin);
  temp = discretize(axs,axsBinned);
  cBinned = accumarray(temp,c,[],@mean)';
  axsBinned = axsBinned(1:end-1);

  axsBinned = axsBinned((nThrow+1):end-nThrow);
  cBinned = cBinned((nThrow+1):end-nThrow);
end
