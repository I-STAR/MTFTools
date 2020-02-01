function [output] = padarrayto(input, targetSize, varargin)

% pad (or crop) a array into specific size, works for ndim array
%
%   IN:  input (array to be padded)    
%        targetSize (array size after padding)
%        varargin (optional parameter for builtin ~padarray~ function)
%        , which is: (1) padVal(value of pad method), (2) direction
%
%   OUT:
%   EXM: padarrayto(MDCTData,[600 600 350],0,'both')
% 
%   @@@TODO: hann filter etc. support (=array_padd.m=)

  if nargin == 2; varargin = {0, 'both'}; end
  if nargin == 3; varargin{2} = 'both'; end
  
  if length(targetSize) == 3 && targetSize(3) == 1; targetSize = targetSize(1:2); end
  if length(targetSize) == 2 && ndims(input) == 3; targetSize = [targetSize size(input,3)]; end
  
  assert(ndims(input) == length(targetSize), 'Error. Dimension mismatch');
  
  padSize = targetSize - size(input);
  
  if strcmp(varargin{2}, 'both')
    padSizeHalf = ceil(padSize/2);
    output = padarray(input, padSizeHalf, varargin{1}, 'both');
    %%% One way of cropping
    % if any(mod(padSize,2) ~= 0)         % pad one more element, throw away element ~end~ 
    %   temp = repmat({'1:end-1'},[1 ndims(input)]);
    %   % if you want to assign value --> make sure there is element in ~mod(padSize,2) ~= 0~
    %   if any(mod(padSize,2) == 0)
    %     temp{mod(padSize,2) == 0} = ':';
    %   end
    %   output = idxbystr(output, temp);
    % end
    %%% Better way of cropping
    output = idxbystr(output, arrayfun(@genidxcropornot, padSize, 'UniformOutput', false));
  elseif strcmp(varargin{2}, 'pre') || strcmp(varargin{2}, 'post')
    output = padarray(input, padSize, varargin{1}, varargin{2});
  else
    error('Error. Padded direction error.');
  end
  
end

% possible to create annonymous function like this
function [output] = genidxcropornot(input)
  if mod(input, 2) == 0
    output = ':';
  else
    output = '1:end-1';                 % crop (throw away last element)
  end  
end

