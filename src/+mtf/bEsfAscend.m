function out = bEsfAscend(esf)
% Test: whether esf is ascending
% Out: logical, true if esf is ascending
  idx = fix(length(esf)/2);
  out = mean( esf(idx:end) ) > mean( esf(1:idx) );
end