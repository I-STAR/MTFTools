function [idx] = maxIntensityLoc(l, bGradient)
% l: normally should be binary 

  if bGradient
    % better to use combinaation and x and y gradients (in case the line angle is too small)
    % l = gradient(l); % works for 3d as well
    l = gradientuse(l);
  end
  [~, idx] = max(l,[],1);
  idx = permute(idx, [2:ndims(l) 1]);
end

function out = gradientuse(in)
  [gx,gy] = gradient(in);
  out = sqrt(gx.^2 + gy.^ 2);
end