function lsf = esf2lsf(esf, diffMethod)
% input could also be lsf, when `diffMethod` is set as `none`
if nargin == 1; diffMethod = 'gradient'; end
  switch diffMethod
  case 'diff'
    lsf = [diff(esf) 0];
  case 'gradient'
    % but due to smoothing from the central difference ... will not actually give you sinc
    lsf = gradient(esf);
  case 'none'
    lsf = esf;
  end
end
  