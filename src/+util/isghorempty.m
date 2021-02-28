function b = isghorempty(in)
% Predicate: is figure handle or empty
  b = isa(in,'matlab.ui.Figure');
  b = b || isempty(in);
end
