function lsf = esf2lsf(esf, diffMethod)
% Convert ESF to LSF (through numerical diff)
% input could also be lsf, when `diffMethod` is set as `none`
  if nargin == 1; diffMethod = 'gradient'; end
  switch diffMethod
  case 'diff'
    lsf = [diff(esf) 0];
  case 'gradient'
    lsf = gradient(esf);
  case 'none'
    lsf = esf;
  end
end
  