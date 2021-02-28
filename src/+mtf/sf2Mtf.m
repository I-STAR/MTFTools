function [mtfVal, mtfAxis, lsfDetrend, axsDetrend, lsfGrid, axsGrid, sfGrid] = sf2Mtf(sf, axs, dSize, pMtf, pDetrend)
% Calculate MTF from a spread function (either ESF or LSF)
% In: 
%   sf, axs: spread function and its axis (should be of the same length), typically calculated
%            with `mtf.SfCalc`
%   dSize: element spacing in dim1 (unit: mm)
%   pMtf: see `inputParser` below
%   pDetrend: see `inputParser` in `mtf.lsfWdCenter` or `mtf.lsfDetrendWdCenter`
% Out:
%   mtfVal, mtfAxis: mtf and its axis
%   lsfDetrend, axsDetrend: processed lsf and its axis (gridded, windowed, centerred, detrended)
%   lsfGrid, axsGrid: gridded lsf and its axis
%   sfGrid: gridded spread function (ESF or LSF)
% Note:
%   input axis --> unit: voxel --> then you use voxel size to convert to mm
%   `diffMethod` should be set as `none` for LSF input

  P = inputParser;
  % number of pixels removed from both edge
  addParameter(P, 'nRmEdge', 5, @(x) isnumeric(x) && isscalar(x)); 
  % if diffMethod is none --> then lsf is inputted (with wire / slit)
  % gradient for central difference, diff for forward difference
  addParameter(P, 'diffMethod', 'gradient', @ischar); % none/gradient/diff
  % highest frequency in presampling sf (with respect to Nyquist, i.e. 2 is 2 times Nyquist)
  addParameter(P, 'maxFreq', 2, @(x) isnumeric(x) && isscalar(x)); 
  % if true, no detrend (i.e. call `lsfWdCenter` instead of `lsfDetrendWdCenter`)
  addParameter(P, 'bNoDetrend', 0, @util.isloginum); 
  % flag: apply correction for numerical differentiation
  addParameter(P, 'bDiffCorr', 1, @util.isloginum); 
  % flag: do zero padding before Fourier transform
  addParameter(P, 'bZeroPad', 1, @util.isloginum); 
  parse(P, pMtf);
  P = P.Results;
  pDetrend = util.getNVStruct(pDetrend);

  assert(isscalar(dSize));
  if P.bDiffCorr
    if strcmp(P.diffMethod, 'diff'); error('Error. Correction only implemented for central difference.'); end
    if strcmp(P.diffMethod, 'none'); P.bDiffCorr = 0; end
  end
  
  %%% gridding
  if all(util.isdint(axs))
    warning('Warning. Pure integer axis pattern. `P.maxFreq` will not be used.');
    warning('Warning. This approach is not fully tested.');
    sfGrid = accumarray(util.tocolumn(axs),sf,[],@mean)';
    axsGrid = unique(axs)';
  else
    [sfGrid, axsGrid] = mtf.discretizeCurveMaxFreq(sf, axs, P.maxFreq, P.nRmEdge);
  end

  %%% esf2lsf conversion
  [lsfGrid] = mtf.esf2lsf(sfGrid, P.diffMethod);

  if P.bNoDetrend
    [lsfDetrend, axsDetrend, ~] = mtf.lsfWdCenter(lsfGrid, axsGrid, pDetrend);
  else
    [lsfDetrend, axsDetrend, ~] = mtf.lsfDetrendWdCenter(lsfGrid, axsGrid, pDetrend);
  end
  
  lsfDetrend = mtf.lsfNormalize(lsfDetrend, dSize/P.maxFreq);
  [mtfVal, mtfAxis] = mtf.lsf2Mtf(lsfDetrend, dSize/P.maxFreq, P.bDiffCorr, P.bZeroPad);
end
