function [out] = gcf_if()
  if isempty(findobj('type','figure'))
    out = [];
  else
    out = gcf;
  end
end