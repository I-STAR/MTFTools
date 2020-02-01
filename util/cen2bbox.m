function out = cen2bbox(cenCoor, boxSize)
% favor the left side
  cenCoor = fix(cenCoor);
  
  if isscalar(boxSize) && ~isscalar(cenCoor)
    boxSize = repmat(boxSize, [1 length(cenCoor)]);
  end
  
  lBound = cenCoor - boxSize/2;
  lBound = ceil(lBound);
  uBound = lBound + boxSize - 1;
  
  out = [lBound uBound];
end
