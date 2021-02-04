function b = isghorempty(in)
  b = isa(in,'matlab.ui.Figure');
  b = b || isempty(in);
end
