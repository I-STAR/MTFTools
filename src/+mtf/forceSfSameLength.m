function [esfCel, esfAxsCel] = forceSfSameLength(esfCel, esfAxsCel, nBin)
% Make sure all spread function realizations have the same length
  axsLength = cellfun(@length, esfAxsCel);
  lengthUse = min(axsLength);
  for i = 1:nBin
    esfCel{i} = util.croparrayto(esfCel{i}, lengthUse);
    esfAxsCel{i} = util.croparrayto(esfAxsCel{i}, lengthUse);
  end
end