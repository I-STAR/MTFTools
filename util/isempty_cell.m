function out = isempty_cell(in)
  if iscell(in) && length(in) == 1; in = in{:}; end
  out = isempty(in);
end
