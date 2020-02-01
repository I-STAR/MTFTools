function [mtfVal, mtfAxis, mtfCel, mtfError] = sf2Mtf_mult(sfCel, axsCel, dSize, pMtf, pDetrend, varargin)
% apply `sf2Mtf` multiple times, for errorbar generation (purely a wrapper)
  assert(length(sfCel) == length(axsCel));
  nCurve = length(sfCel);

  mtfCel = cell(1, nCurve);
  mtfAxisCel = cell(1, nCurve);
  for i = 1:nCurve
    [ mtfCel{i}, mtfAxisCel{i} ] = mtf.sf2Mtf(sfCel{i}, axsCel{i}, dSize, pMtf, pDetrend);
  end

  [mtfAxis, mtfVal, mtfCel, mtfError] = averageMtf(mtfAxisCel, mtfCel);
end

function [mtfAxis, mtfVal, mtfCel, mtfError] = averageMtf(mtfAxisCel, mtfCel)
% with some padding (make same length)
  [ls] = cellfun(@(x) length(x), mtfAxisCel);
  [maxLs, idx] = max(ls);
  mtfAxis = mtfAxisCel{idx};
  nCurve = length(mtfAxisCel);
  
  for i = 1:nCurve
    if length(mtfAxisCel{i}) ~= maxLs
      mtfCel{i} = interp1(mtfAxisCel{i}, mtfCel{i}, mtfAxis);
    end
  end
  
  mtfValMatrix = zeros(nCurve, length(mtfAxis));
  for i = 1:nCurve
    mtfValMatrix(i,:) = mtfCel{i};
  end
  mtfVal = mean(mtfValMatrix,1);
  mtfError = std(mtfValMatrix,0,1);
end
