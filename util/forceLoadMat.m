function out = forceLoadMat(filePath, varName)
% Input: filePath, char, file path
%        varName, char, variable name (Optional)
% Note: only to load one variable
  if nargin == 1; varName = []; end
  assert(ischar(filePath));
  temp = load(filePath);
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
