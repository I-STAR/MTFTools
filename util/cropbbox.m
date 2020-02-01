function [output] = cropbbox(in, bbox)

% Crop data by inputted bounding box
%
%   IN:  bbox, mat convention
%
%   OUT:   
  
  if bbox == -1
    output = in;
    return
  end
  
  if ndims(in) ~= length(bbox) / 2
    % Original solution
    % temp = bbox2cell_proj(bbox, size(in));
    
    % New solution
    sz = sizevec(in, (length(bbox)/2+1):ndims(in));
    sz_inc = [ones(length(sz),1), transpose(sz)];
    
    bbox = bboxincdim(bbox, sz_inc);
    temp = bbox2cell(bbox);
  else
    temp = bbox2cell(bbox);
  end
  
  output = in(temp{:});
  
end

