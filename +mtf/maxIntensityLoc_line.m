function [idx] = maxIntensityLoc_line(l)
% binary segmentation --> but unlike the edge method...do not use gradient
% see also, maxLineIntensityLoc_edge
  l = imbinarize(l / max(l(:)));
  [~, idx] = max(l,[],1);
  idx = transpose(idx);
end