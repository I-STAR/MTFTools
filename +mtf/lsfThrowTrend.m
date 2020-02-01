function [lsf, lsfAxis, rg] = lsfThrowTrend(lsf, lsfAxis, varargin)
% Detrend (detrend the primary data), and then throw away the trend (throw can be controlled (through flag))
% Will center the data as well (center based on the number of points, not on the absolute coor)
%   therefore, you can use `figure, plot(lsf);` to see the centering effect.
%
% Note:
% 1. peak needs to be higher than flat bottom (not an inverted gaussian) @@@TODO (auto flip)

  P = inputParser;
  % two row vector, lsf and lsfAxis, the axis does not need to be sorted
  addRequired(P, 'lsf', @(x) validateattributes(x, {'numeric'}, {'size', [1 nan]}));
  addRequired(P, 'lsfAxis', @(x) validateattributes(x, {'numeric'}, {'size', [1 nan]}));
  % fh --> function handle
  % fh_lsf: function handle for lsf, fh_trend: function handle for trend
  addParameter(P, 'fh_lsf', 'gauss1', @(x) ischar(x) || isfh(x));
  addParameter(P, 'fh_trend', 'poly1', @(x) ischar(x) || isfh(x));
  % length of the windowed data -- primary (does not include trend) -- (x, scale of FWHM)
  % primary data will not be used for trend calculation (fitting)
  addParameter(P, 'primaryLength', 4, @(x) isnumsca(x));
  % length of the windowed data -- total -- (x, scale of FWHM)
  % trend outside of this margin will be thrown (if `bThrowTrend` set as 1)
  addParameter(P, 'marginLength', 8, @(x) isnumsca(x));
  % move the lsf back to the base line (so that Gaussian fitting can be accurate)
  % if empty --> move the lowest point to 0
  addParameter(P, 'lsfBase', 0, @isnumeric);
  % redo the lsf fitting after the detrend, so two lsf fitting in total, one trend fitting
  addParameter(P, 'bRefit', 0, @isnumeric);
  % keep non-primary data? (1 --> do not keep)
  addParameter(P, 'bThrowTrend', 1, @isnumeric);
  addParameter(P, 'bDebug', 1, @isnumeric);
  parse(P, lsf, lsfAxis, varargin{:});
  P = P.Results;

  bDebug = P.bDebug;
  primarySca = P.primaryLength;
  marginSca = P.marginLength;

  %%% Move to the base line
  if isempty(P.lsfBase); P.lsfBase = min(lsf); end
  lsf = lsf - P.lsfBase;

  %%% Center and Window and detrend
  w = abs(lsfAxis' - median(lsfAxis));
  % fit to determine FWHM
  % higher weights for central data (while higher weights for edge data for trend fitting)
  
  fh_lsf = fit(lsfAxis',double(lsf'),P.fh_lsf,'Weights',(max(w)-w).^5);   
  [temp, cen] = max(fh_lsf(lsfAxis'));
  fwhm = fix(diff(polyxpoly([1 length(lsf)],[temp/2 temp/2],1:length(lsf),fh_lsf(lsfAxis'))));
  rg = mtf.calcRg_scaleFwhm(primarySca, fwhm, cen, length(lsf));
  
  lsfTrend = lsf - fh_lsf(lsfAxis')'; 
  
  weightTrend = abs(lsfAxis' - median(lsfAxis));
  weightTrend(rg) = 0;
  fh_Trend = fit(lsfAxis',double(lsfTrend'),P.fh_trend, 'Weights', weightTrend);
  
  if bDebug; figure,plot(lsfAxis, lsf, '*'); hold on; plot(lsfAxis, fh_lsf(lsfAxis')', '-'); end
  if bDebug; plot(lsfAxis, fh_Trend(lsfAxis')'); end
  
  lsf = lsf - fh_Trend(lsfAxis')';
  
  if P.bRefit
    fh_lsf = fit(lsfAxis',double(lsf'),P.fh_lsf,'Weights',(max(w)-w).^2);
    [temp, cen] = max(fh_lsf(lsfAxis'));
    fwhm = fix(diff(polyxpoly([1 length(lsf)],[temp/2 temp/2],1:length(lsf),fh_lsf(lsfAxis'))));
    rg = mtf.calcRg_scaleFwhm(primarySca, fwhm, cen, length(lsf));
    if bDebug; figure; plot(lsfAxis, lsf, '*'); hold on; plot(lsfAxis, fh_lsf(lsfAxis')', '-s'); end
  end

  if bDebug; plot(lsfAxis, lsf, '*'); end

  %%% Move to baseline one more time
  baseFinder = lsf([1:rg(1) rg(end):end]);
  lsf = lsf - mean(baseFinder(:));

  %%% Throw trend
  if P.bThrowTrend
    lsf([1:rg(1) rg(end):end]) = 0;
  end

  %%% Throw away points that are too far to be trend
  rg = mtf.calcRg_scaleFwhm(marginSca, fwhm, cen, length(lsf));
  lsfAxis = lsfAxis(rg);
  lsf = lsf(rg);
  
  if bDebug; plot(lsfAxis, lsf, 'd'); end
end

