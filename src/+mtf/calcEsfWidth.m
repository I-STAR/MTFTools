function [out, fitRes] = calcEsfWidth(esf, esfAxis, dSize, varargin)
% Calculate the width of ESF (by fitting an error function)
% in: same input sequence as mtf.sf2mtf
% out: esf width in mm
% width would be the sigma of Gaussian (after derivative)
% https://en.wikipedia.org/wiki/Error_function
% Note:
%   - esf is recommended to be ascending

  p = inputParser;
  addParameter(p, 'bDebug', 0);
  parse(p, varargin{:});
  p = p.Results;

  assert(isscalar(dSize));

  esfAxis = esfAxis * dSize;
  esfUse = double(esf);
  esfeqn = 'a - (b/2) * erf((x-c) / (sqrt(2) * d))';
  profLength = max(esfAxis)-min(esfAxis);
  starts = [mean(esfUse), abs(max(esfUse)-min(esfUse)), profLength/2, profLength/10];
  
  % if smooth needed (not recommended)
  % esfUse = smooth(double(esf),5,'sgolay');
  fitRes = fit(double(esfAxis),esfUse,esfeqn,'Start',starts,'MaxIter',1000);

  out = fitRes.d;

  if p.bDebug
    figure; plot(esfAxis - median(esfAxis), esfUse, '*', 'MarkerSize', 2); hold on;
    plot(esfAxis - median(esfAxis), fitRes(esfAxis), 'LineWidth', 3);
    xlim([min(esfAxis - median(esfAxis)) max(esfAxis - median(esfAxis))]);
    disp(['Resolution is: ', num2str(fitRes.d)]);
  end
end
