function [output] = croparrayto(input, targetSize, varargin)
% Crop array to a given size 
%   IN: input (array to be cropped)    
%       targetSize (array size after cropping)
%
%   OUT:   
  assert(isnumeric(input) || islogical(input) && isnumeric(targetSize));
  if ndims(input) - 1 == length(targetSize)
    targetSize = [targetSize size(input, ndims(input))];
  elseif ndims(input) + 1 == length(targetSize) && targetSize(end) == 1
  % special issue, ending with 1 dim size
    targetSize = targetSize(1:end-1);
  end
    
  assert(ndims(input) == length(targetSize), 'Error. Dimension mismatch');
  
  cenCoor = ceil(size(input)/2);
  cropLengthLeft = floor(targetSize/2);
  newCoorLeft = cenCoor - cropLengthLeft;
  newCoorRight = newCoorLeft + (targetSize-1);
  
  newCoor = cell(1,length(newCoorLeft));
  for i = 1:length(newCoorLeft)
    newCoor{i} = newCoorLeft(i):newCoorRight(i);
    if mod(targetSize(i),2) == 0
      newCoor{i} = newCoor{i} + 1;
    end
  end

  output = input(newCoor{:});
end

