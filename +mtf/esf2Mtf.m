function [mtf, mtfAxis, lsf, lsfAxis] = esf2Mtf(esf, axs, out_dSize, varargin)
% ARCHIVED, replaced with `sf2mtf`
% esf and axs are typically output from function discretizeCurve
% out_dSize, which is typically dSize/maxFreqOut
  ns = module;
  P = inputParser;
  addParameter(P, 'diffMethod', 'gradient', @ischar); 
  addParameter(P, 'bCorr', 0, @(x) isempty(x) || isfh(x)); 
  addParameter(P, 'nPointsThrow', 4, @isnumeric); 
  addParameter(P, 'fh_lsfProc', ...
               @(x,xAxis) ns.lsfWdCenter(x, xAxis, 'marginLength', 8, 'fh_lsf', 'gauss1'), ...
               @isfh); 
  parse(P, varargin{:});
  P = P.Results;

  switch P.diffMethod
  case 'diff'
    lsf = diff(esf);
  case 'gradient'
    % but due to smoothing from the central difference ... will not actually give you sinc
    lsf = gradient(esf);
  end

  rg = (P.nPointsThrow+1):(length(lsf)-P.nPointsThrow);

  lsf = lsf(rg);
  axs = axs(rg);

  [lsf, lsfAxis] = P.fh_lsfProc(lsf, axs);
  
  % lsf should be regular gridded 1d lsf (row or column)
  lsf = ns.lsfNormalize(lsf, out_dSize);
  [mtf, mtfAxis] = ns.lsf2Mtf(lsf, out_dSize, P.bCorr);
end
