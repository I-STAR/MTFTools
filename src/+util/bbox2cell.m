function out = bbox2cell(input)
% Convert bounding box to cell array
  if length(input) == 2
    out = {input(1):input(2)};
  elseif length(input) == 4
    out = {input(1):input(3), input(2):input(4)};
  elseif length(input) == 6
    out = {input(1):input(4), input(2):input(5), input(3):input(6)};
  end
end

