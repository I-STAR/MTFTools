function [output] = cropbbox(in, bbox)
% Crop data `in` by inputted bounding box `bbox`
%   IN:  bbox, mat convention
%   OUT:   
  
  if isequal(bbox, -1) || isempty(bbox)
    output = in;
    return
  end
  
  if ndims(in) ~= length(bbox) / 2
    sz = size(in, (length(bbox)/2+1):ndims(in));
    sz_inc = [ones(length(sz),1), transpose(sz)];
    bbox = bboxincdim(bbox, sz_inc);
    temp = util.bbox2cell(bbox);
  else
    temp = util.bbox2cell(bbox);
  end
  
  output = in(temp{:});
end

function [output] = bboxincdim(in, sz)
  validateattributes(sz,{'numeric'},{'size', [nan 2]});
  in = reshape(in, [], 2);
  output = [in; sz];
  output = output(:)';
end