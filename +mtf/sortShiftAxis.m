function [esf, esfAxis] = sortShiftAxis(esf, esfAxis)
% sorted (ascending), and shifted (starts from 1)
% useful for gridding step (followed)
  esfAxis = esfAxis - min(esfAxis) + 1;
  [esfAxis, idx] = sort(esfAxis);
  esf = esf(idx);
end