function [idx] = minIntensityLoc_line(l)
% binary segmentation --> but unlike the edge method...do not use gradient
% dark slit...
  l = imbinarize(l / max(l(:)));
  [~, idx] = min(l,[],1);
  idx = transpose(idx);
end