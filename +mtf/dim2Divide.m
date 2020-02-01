function [uCel, locCel, esfCel, esfAxsCel] = dim2Divide(u, nBin, loc)
  celSz = floor(size(u,2)/(nBin));
  dimDivide = repmat(celSz,[1 nBin-1]);
  dimDivide = [dimDivide size(u,2)-sum(dimDivide)];
  
  uCel = mat2cell(u, size(u,1), dimDivide, size(u,3));
  locCel = mat2cell(loc, dimDivide, size(loc,2));
  esfCel = cell(1, nBin);
  esfAxsCel = esfCel;
end