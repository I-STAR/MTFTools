function [lsf, lsfAxis, rg] = lsfWdCenter(lsf, lsfAxis, varargin)
% Center and then window the LSF function (simplified version of lsfDetrendWdCenter)
% no detrending performed

  P = inputParser;
  % two row vector, lsf and lsfAxis, the axis does not need to be sorted
  addRequired(P, 'lsf', @(x) validateattributes(x, {'numeric'}, {'size', [1 nan]}));
  addRequired(P, 'lsfAxis', @(x) validateattributes(x, {'numeric'}, {'size', [1 nan]}));
  addParameter(P, 'fh_lsf', 'gauss1', @(x) ischar(x) || util.isfh(x));
  addParameter(P, 'marginLength', 8, @(x) util.isnumsca(x));
  parse(P, lsf, lsfAxis, varargin{:});
  P = P.Results;

  marginSca = P.marginLength;

  %%% Center
  w = abs(lsfAxis' - median(lsfAxis));

  %%% Window
  % fit to determine FWHM
  % higher weights for central data (while higher weights for edge data for trend fitting)
  fh_lsf = fit(lsfAxis',double(lsf'),P.fh_lsf,'Weights',(max(w)-w).^2);      % 1 Term Gaussian
  [temp, cen] = max(fh_lsf(lsfAxis'));
  fwhm = fix(diff(polyxpoly([1 length(lsf)],[temp/2 temp/2],1:length(lsf),fh_lsf(lsfAxis'))));
  rg = mtf.calcRg_scaleFwhm(marginSca, fwhm, cen, length(lsf));
  lsfAxis = lsfAxis(rg);
  lsf = lsf(rg);
  
  lsfAxis = lsfAxis - min(lsfAxis);
end



