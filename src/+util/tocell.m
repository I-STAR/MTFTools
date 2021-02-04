function [outCel] = tocell(in)
% Note:
% 1. empty input --> empty cell
  if(isempty(in))
    outCel = {}; % isempty will still output empty of course
  else
    if(iscell(in))
      outCel = in;
    else
      outCel = {in};
    end
  end
end

