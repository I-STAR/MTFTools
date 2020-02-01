function [idx] = maxIntensityLoc_edge(l)
% binary --> gradient operation is performed
% see also, maxLineIntensityLoc_line
  l = imbinarize(l / max(l(:)));
  l = gradient(l);
  [~, idx] = max(l,[],1);
  idx = idx';
end