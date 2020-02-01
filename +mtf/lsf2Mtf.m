function [mtf, mtfAxis] = lsf2Mtf(lsf, dSize, bCorr)
% bCorr, accounts for numerical difference error (used in e.g. ESF calculation)
% http://www.imatest.com/2015/04/lsf-correction-factor-for-slanted-edge-mtf-measurements/
% should only be applied if you use central difference
  if nargin == 2; bCorr = false; end

  nP = 2^ceil(log2(2*length(lsf)));     % number of points for fft
  
  mtf = fftshift(abs(fft(lsf,nP)) * dSize);
  
  mtfAxis = (-nP/2:nP/2-1)*(1/(nP*dSize));

  % Throw negative part
  idxZero = ceil(length(mtfAxis)/2)+1;
  mtf = mtf(idxZero:end);
  mtfAxis = mtfAxis(idxZero:end);
  
  if bCorr
    scaFac = pi*(1:length(mtf))/nP;
    mtf = mtf .* min(scaFac./sin(scaFac), 10);
  end
end