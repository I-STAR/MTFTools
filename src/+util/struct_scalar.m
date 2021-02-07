function [out] = struct_scalar(varargin)
% Avoid struct expansion in matlab
  out = struct();
  for i = 1:length(varargin)/2
    out.(varargin{2*i-1}) = varargin{2*i};
  end
end

