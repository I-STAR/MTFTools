function [names, values] = getNamesValues(varargin)
  if isempty(varargin)
    names = {};
    values = {};
  elseif isstruct(varargin{1})
    names = fieldnames(varargin{1});
    values = struct2cell(varargin{1});
  elseif ischar(varargin{1})
    names = varargin(1:2:end);
    values = varargin(2:2:end);
    assert(length(names) == length(values), 'Error. Number of names should match number of values.');
  elseif length(varargin) == 2 && iscell(varargin{1}) && iscell(varargin{2})
    names = varargin{1};
    values = varargin{2};
    assert(length(names) == length(values), 'Error. Number of names should match number of values.');
  else
    error('Error. Unsupported input format.');
  end
end

