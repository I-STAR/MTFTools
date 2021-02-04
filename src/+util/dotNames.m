function [output] = dotNames(in, fNames)
  assert(length(in) == 1);
  output = struct;

  fNames = util.tocell(fNames);

  for i = 1:length(fNames)
    n = fNames{i};
    try
      output.(n) = in.(n);
    catch
      error(['Error. Field/Property name ', num2str(n), ' does not exist']);
    end
  end
end






