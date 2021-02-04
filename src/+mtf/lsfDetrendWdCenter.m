function [lsf, lsfAxis, rg] = lsfDetrendWdCenter(lsf, lsfAxis, varargin)
% lsfDetrendWdCenter - Detrending, windowing, and centering the LSF
% Note:
%   1. lsf should be bell shaped (not the inverse)

  P = inputParser;
  addRequired(P, 'lsf', @(x) validateattributes(x, {'numeric'}, {'size', [1 nan]}));
  addRequired(P, 'lsfAxis', @(x) validateattributes(x, {'numeric'}, {'size', [1 nan]}));
  % fh_lsf: function handle/name for lsf/primary, fh_trend: function handle/name for trend
  addParameter(P, 'fh_lsf', 'gauss1', @(x) ischar(x) || util.isfh(x));
  addParameter(P, 'fh_trend', 'poly1', @(x) ischar(x) || util.isfh(x));
  % length of the primary data, unit: scale of FWHM
  % primary data will not be used for trend calculation (marginal data will)
  addParameter(P, 'primaryLength', 6, @(x) util.isnumsca(x));
  % length of the primary + marginal data, unit: scale of FWHM
  % data outside of this margin will be thrown
  addParameter(P, 'marginLength', 12, @(x) util.isnumsca(x));
  % move the lsf back to the base line by the given amount (before fitting)
  % if empty --> move the lowest point to 0
  addParameter(P, 'lsfBase', 0, @isnumeric);
  % redo primary fitting after detrending
  addParameter(P, 'bRefit', 0, @isnumeric);
  % set marginal data to 0 at the end
  addParameter(P, 'bZeroMargin', 1, @isnumeric);
  addParameter(P, 'bDebug', 0, @isnumeric);
  parse(P, lsf, lsfAxis, varargin{:});
  P = P.Results;

  bDebug = P.bDebug;
  primarySca = P.primaryLength;
  marginSca = P.marginLength;

  %%% Move to the base line
  if isempty(P.lsfBase); P.lsfBase = min(lsf); end
  lsf = lsf - P.lsfBase;

  %%% Detrend, Window, Center
  w = abs(lsfAxis' - median(lsfAxis));
  % fit primary to determine FWHM
  % higher weights for central data (while higher weights for edge data for trend fitting)
  
  fh_lsf = fit(lsfAxis',double(lsf'),P.fh_lsf,'Weights',(max(w)-w).^5);   
  [temp, cen] = max(fh_lsf(lsfAxis'));
  % fwhm determined on fitted function (not original noisy one)
  fwhm = fix(diff(polyxpoly([1 length(lsf)],[temp/2 temp/2],1:length(lsf),fh_lsf(lsfAxis'))));
  rg = mtf.calcRg_scaleFwhm(primarySca, fwhm, cen, length(lsf));
  
  lsfTrend = lsf - fh_lsf(lsfAxis')'; 
  
  weightTrend = abs(lsfAxis' - median(lsfAxis));
  weightTrend(rg) = 0;
  fh_Trend = fit(lsfAxis',double(lsfTrend'),P.fh_trend, 'Weights', weightTrend);
  
  if bDebug
    axisPlotFit = linspace(min(lsfAxis), max(lsfAxis), 1e3);
    figure,plot(lsfAxis, lsf, '*'); hold on; 
    plot(axisPlotFit, fh_lsf(axisPlotFit')', '-'); 
    plot(axisPlotFit, fh_Trend(axisPlotFit')', '-');
  end

  % actual detrending step
  lsf = lsf - fh_Trend(lsfAxis')';
  if bDebug; plot(lsfAxis, lsf, '*'); end
  
  % refit for a better FWHM estimation only
  if P.bRefit
    fh_lsf = fit(lsfAxis',double(lsf'),P.fh_lsf,'Weights',(max(w)-w).^2);
    [temp, cen] = max(fh_lsf(lsfAxis'));
    fwhm = fix(diff(polyxpoly([1 length(lsf)],[temp/2 temp/2],1:length(lsf),fh_lsf(lsfAxis'))));
    rg = mtf.calcRg_scaleFwhm(primarySca, fwhm, cen, length(lsf));
    if bDebug
      plot(axisPlotFit, fh_lsf(axisPlotFit')', '-'); 
    end
  end
  assert(~isempty(rg),'Error. Unknown fitting pattern.');
  %%% Move to baseline one more time (i.e. after detrending, margin should be 0 mean)
  baseFinder = lsf([1:rg(1) rg(end):end]);
  lsf = lsf - mean(baseFinder(:));

  %%% Zero out the marginal region 
  if P.bZeroMargin
    lsf([1:rg(1) rg(end):end]) = 0;
  end

  %%% Throw away points that are outside the margin
  rg = mtf.calcRg_scaleFwhm(marginSca, fwhm, cen, length(lsf));
  lsfAxis = lsfAxis(rg);
  lsf = lsf(rg);
  
  if bDebug
    plot(lsfAxis, lsf, 'd'); 
    if P.bRefit
      legend({'Original LSF','Fitted LSF (Primary)','Fitted Trend','Detrended LSF','Refitted LSF','Final LSF'});
    else
      legend({'Original LSF','Fitted LSF (Primary)','Fitted Trend','Detrended LSF','Final LSF'});
    end
  end
end

