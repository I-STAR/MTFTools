function out = forceLoadMat(filePath, varName)
% Input: filePath, char, file path (does not have to end with .mat)
%        varName, char, variable name (Optional)
  if nargin == 1; varName = []; end
  assert(ischar(filePath));
  temp = load(filePath, '-mat'); % the other alternative being '-ascii'
  tempNames = fieldnames(temp); % Cell
  if isempty(varName)
    if length(tempNames) ~= 1
      error('Error: more than one variables are found.');
    else
      out = temp.(tempNames{:});
    end
  else
    if ~ismember(varName, tempNames)
      error('Error: variable name not found');
    else
      out = temp.(varName);
    end
  end
end
