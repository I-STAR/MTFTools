function [mtfVal, mtfAxis, lsfDetrend, axsDetrend, lsfGrid, axsGrid, sfGrid] = sf2Mtf(sf, axs, dSize, pMtf, pDetrend)
% Note: input axis --> unit: voxel --> then you use voxel size to convert to mm

  P = inputParser;
  addParameter(P, 'nRmEdge', 5, @(x) isnumeric(x) && isscalar(x)); % number of pixels removed from both edge
  % if diffMethod is none --> then lsf is inputted (with wire / slit)
  % gradient for central difference, diff for forward difference
  addParameter(P, 'diffMethod', 'gradient', @ischar); 
  % highest frequency in presampling sf
  addParameter(P, 'maxFreq', 2, @(x) isnumeric(x) && isscalar(x)); 
  % flag: apply correction for numerical differentiation
  addParameter(P, 'bDiffCorr', 1, @isloginum); 
  parse(P, pMtf);
  P = P.Results;

  assert(isscalar(dSize));
  if P.bDiffCorr; assert(strcmp(P.diffMethod, 'gradient'), 'Error. Correction only implemented for central difference.'); end
  
  %%% gridding
  [sfGrid, axsGrid] = mtf.discretizeCurveMaxFreq(sf, axs, P.maxFreq, P.nRmEdge); 

  %%% esf2lsf conversion
  [lsfGrid] = mtf.esf2lsf(sfGrid, P.diffMethod);

  if isempty(pDetrend)
    % a naive way of window & center, see also `lsfWdCenter` @@@TODO
    cenIdx = fix(mean(axsGrid));
    rg = -3:3;
    maxNum = max(lsfGrid(cenIdx+rg));
    idx = lsfGrid >= -maxNum*0.3 & lsfGrid <= maxNum;
    lsfDetrend = lsfGrid(idx);
    axsDetrend = axsGrid(idx);
  else
    [lsfDetrend, axsDetrend, ~] = mtf.lsfThrowTrend(lsfGrid, axsGrid, pDetrend);
  end
  
  lsfDetrend = mtf.lsfNormalize(lsfDetrend, dSize/P.maxFreq);
  [mtfVal, mtfAxis] = mtf.lsf2Mtf(lsfDetrend, dSize/P.maxFreq, P.bDiffCorr);
end
