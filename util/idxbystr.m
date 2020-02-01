function [output] = idxbystr(input, idxStr, idxType) %#ok
%   IN: input, data to be indexed
%       idxStr, string or cell, e.g. ('1:end,1:end-1', {'1:end', ':'})
%       idxType, idxType, enumeration: '()', '{}', or '[]'
%   OUT:   

  if nargin == 2; idxType = '()'; end
  if iscell(idxStr); idxStr = strjoin(idxStr,','); end
  assert(ismember(idxType, {'()', '{}', '[]'}), 'Error. =idxType= not suppored');
  eval(['output = input', idxType(1), idxStr, idxType(2), ';']);
end

