function [esf, esfAxis] = sortShiftRevertAxis(esf, esfAxis, bRevert)
% Sort (esf axis ascending), shift (axis starts from 1), revert (so that esf value ascending) ESF axis
  esfAxis = esfAxis - min(esfAxis) + 1;
  [esfAxis, idx] = sort(esfAxis);
  esf = esf(idx);

  if bRevert == -1 % guess
    bRevert = ~mtf.bEsfAscend(esf);
  end

  if bRevert
    esfAxis = max(esfAxis) - (esfAxis-1);
    esfAxis = esfAxis(end:-1:1);
    esf = esf(end:-1:1);
  end
end