function [out] = cenSlice(in, nSlice)
% Syntax: 
%
%   IN:  
%
%   OUT:   
  if nargin == 1; nSlice = 1; end

  if ismatrix(in)
    out = in;
  else
    temp = ceil(size(in,3)/2);
    rgShift = (1:nSlice) - ceil(mean(1:nSlice));
    out = in(:,:,temp+rgShift);
  end
end

