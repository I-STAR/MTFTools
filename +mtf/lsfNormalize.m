function lsf = lsfNormalize(lsf, voxSize)
% voxSize: after super-sample

  % voxSize will be cancelled out...but in theory it is the right thing to do
  lsf = lsf / (sum(lsf) * voxSize);
end